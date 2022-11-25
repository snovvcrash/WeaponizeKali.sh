#!/usr/bin/env python3

"""
Print all node names to console (useful when developing the report).

Usage: bloodhound-print.py {u|c|g|d|all} '<QUERY>'
"""

import sys
import json
from pathlib import Path
from neo4j import GraphDatabase

configjson = Path.home() / '.config' / 'bloodhound' / 'config.json'
with open(configjson, 'r') as f:
	config = json.load(f)

try:
	username = config['databaseInfo']['user']
except KeyError:
	username = 'neo4j'

try:
	password = config['databaseInfo']['password']
except KeyError:
	password = None

uri = "bolt://localhost:7687"
driver = GraphDatabase.driver(uri, auth=(username, password), encrypted=False)

with driver.session() as session:
	with session.begin_transaction() as tx:
		result = tx.run(sys.argv[2])

label = sys.argv[1]
if label == 'u':
	label = 'User'
elif label == 'c':
	label = 'Computer'
elif label == 'g':
	label = 'Group'
elif label == 'd':
	label = 'Domain'
else:
	label = 'all'

uniq = set()
for record in result.data():
	for path in record['p']:
		for node in path.nodes:
			labels = node.labels
			name = node['name']
			if (label == 'User' and '@' in name and label in labels)             \
				or (label == 'Computer' and '@' not in name and label in labels) \
				or (label == 'Group' and label in labels)                        \
				or (label == 'Domain' and label in labels)                       \
				or label == 'all':
				if name not in uniq:
					uniq.add(name)

for name in sorted(uniq):
	print(name)
