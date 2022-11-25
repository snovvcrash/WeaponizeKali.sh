#!/usr/bin/env python3

"""
Recursively list all members of a group.

Example: bh_get_ad_group_member.py 'DOMAIN ADMINS@MEGACORP.LOCAL'
"""

import sys
import json
import glob

with open(glob.glob('[0-9]*_groups.json')[0], 'r', encoding='utf-8-sig') as f:
	groups = json.load(f)['data']

with open(glob.glob('[0-9]*_users.json')[0], 'r', encoding='utf-8-sig') as f:
	users = json.load(f)['data']

with open(glob.glob('[0-9]*_computers.json')[0], 'r', encoding='utf-8-sig') as f:
	computers = json.load(f)['data']


def get_ad_group_member(group_name_or_sid, found=[]):
	for group in groups:
		if any(group_name_or_sid == name_or_sid for name_or_sid in (group['Properties']['name'], group['ObjectIdentifier'])):
			for member in group['Members']:
				if member['ObjectType'] == 'Group':
					get_ad_group_member(member['ObjectIdentifier'], found)
				elif member['ObjectType'] == 'User':
					for user in users:
						if user['ObjectIdentifier'] == member['ObjectIdentifier']:
							found.append(user['Properties']['name'])
				elif member['ObjectType'] == 'Computer':
					for computer in computers:
						if computer['ObjectIdentifier'] == member['ObjectIdentifier']:
							found.append(computer['Properties']['name'])
	return found


for user in get_ad_group_member(sys.argv[1]):
	print(user)
