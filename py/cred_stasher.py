#!/usr/bin/env python3

import requests
from random import choice
from emoji import emojize
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument('-U', '--userfile', help='file with usernames')
parser.add_argument('-P', '--passfile', help='file with passwords')
parser.add_argument('-UP', '--userpassfile', help='file with usernames and passwords separated with ":"')
parser.add_argument('-d', '--domain', default=None, help='domain string')
parser.add_argument('--emoji', action='store_true', default=False, help='passwords are masked with emojis ^^')
args = parser.parse_args()


class Stasher:

	def __init__(self, usernames, passwords, domain=None, emoji=False):
		self.domain = domain

		self.emoji_shortcodes = None
		if emoji:
			self.emoji_shortcodes = requests.get('https://gist.github.com/snovvcrash/b9b0f717bbd36d420d79899fc55c4c88/raw/603def33e50d3f23807170ee2ca2069d89967adb/emoji_shortcodes.txt').text.splitlines()

		if type(usernames) is not list:
			with open(usernames, 'r', encoding='utf-8') as f:
				usernames = f.read().splitlines()

		self.usernames = [u.strip() for u in usernames if u]

		if type(passwords) is not list:
			with open(passwords, 'r', encoding='utf-8') as f:
				passwords = f.read().splitlines()

		self.passwords = [p.strip() for p in passwords if p]

	def _process_usernames(self):
		if self.domain:
			self.usernames = [f'{self.domain.upper()}\\{u}' for u in self.usernames]

	def _process_passwords(self):
		stashed = []
		for password in self.passwords:
			curr_pass = ''
			for i, c in enumerate(password):
				if i < 2 or i > len(password)-3:
					curr_pass += c
				else:
					if not self.emoji_shortcodes:
						curr_pass += '*'
					else:
						curr_pass += emojize(f':{choice(self.emoji_shortcodes)}:')

			stashed.append(curr_pass)

		self.passwords = stashed

	def run(self):
		self._process_usernames()
		self._process_passwords()
		return sorted(f'{u}:{p}' for u, p in zip(self.usernames, self.passwords))


if __name__ == '__main__':
	if args.userfile and args.passfile:
		usernames = args.userfile
		passwords = args.passfile
	elif args.userpassfile:
		usernames, passwords = [], []
		with open(args.userpassfile, 'r', encoding='utf-8') as f:
			for line in f:
				username, password = line.split(':', 1)
				usernames.append(username)
				passwords.append(password)

	stasher = Stasher(usernames, passwords, args.domain, args.emoji)
	result = stasher.run()

	print('\n'.join(result))
