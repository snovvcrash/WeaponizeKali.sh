#!/usr/bin/env python3

"""
Recursively list all groups which the user is a member of.

Example: bh_get_ad_user_memberof.py 'SNOVVCRASH@MEGACORP.LOCAL'
"""

import sys
import json
import glob

with open(glob.glob('[0-9]*_groups.json')[0], 'r', encoding='utf-8-sig') as f:
	groups = json.load(f)['data']

with open(glob.glob('[0-9]*_users.json')[0], 'r', encoding='utf-8-sig') as f:
	users = json.load(f)['data']


def get_ad_user_memberof(user_name):
	for user in users:
		if user['Properties']['name'] == user_name:
			user_sid = user['ObjectIdentifier']

	found = []
	for group in groups:
		for member in group['Members']:
			if member['ObjectType'] == 'User' and member['ObjectIdentifier'] == user_sid:
				found.append(group['Properties']['name'])
				found = get_ad_user_memberof_helper(group['ObjectIdentifier'], found)

	return found


def get_ad_user_memberof_helper(group_sid, found=[]):
	for group in groups:
		for member in group['Members']:
			if member['ObjectType'] == 'Group' and member['ObjectIdentifier'] == group_sid:
				found.append(group['Properties']['name'])
				get_ad_user_memberof_helper(group['ObjectIdentifier'], found)

	return found


for group in get_ad_user_memberof(sys.argv[1]):
	print(group)
