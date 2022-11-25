#!/usr/bin/env python3

import csv
import json
import glob

with open(glob.glob('[0-9]*_domains.json')[0], 'r', encoding='utf-8-sig') as f:
	domains = json.load(f)['data']


def get_domain_trust_mapping():
	with open('trusts.csv', 'w') as f:
		writer = csv.writer(f, quoting=csv.QUOTE_ALL)

		header = ['SourceName', 'TargetName', 'TrustType', 'TrustAttributes', 'TrustDirection', 'WhenCreated', 'WhenChanged']
		writer.writerow(header)

		for domain in domains:
			source_name = domain['Properties']['name']

			for trust in domain['Trusts']:
				row = []

				row.append(source_name.lower())  # SourceName
				row.append(trust['TargetDomainName'].lower())  # TargetName
				row.append('WINDOWS_ACTIVE_DIRECTORY')  # TrustType

				# TrustAttributes
				if trust['TrustType'] == 'ParentChild':
					row.append('WITHIN_FOREST')
				elif trust['TrustType'] == 'Forest':
					row.append('FOREST_TRANSITIVE')
				elif trust['TrustType'] == 'External':
					row.append('TREAT_AS_EXTERNAL')
				elif trust['TrustType'] == 'Unknown':
					row.append(None)

				row.append(trust['TrustDirection'])  # TrustDirection
				row.append(None)  # WhenCreated
				row.append(None)  # WhenChanged

				writer.writerow(row)

				if trust['TrustDirection'] == 'Bidirectional':
					row[0], row[1] = row[1], row[0]
					writer.writerow(row)


get_domain_trust_mapping()
