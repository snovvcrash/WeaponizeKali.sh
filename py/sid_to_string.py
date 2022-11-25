#!/usr/bin/env python3

"""
Convert a base64 binary SID to string.

Example: sid_to_string.py AQQAAAAAAAUVAAAATMNQSebVC1Z3fThF
Stolen from: https://stackoverflow.com/a/33188414
"""

import sys
import struct
from base64 import b64decode


def convert(binary):
    version = struct.unpack('B', binary[:1])[0]
    assert version == 1, version
    length = struct.unpack('B', binary[1:2])[0]
    authority = struct.unpack('>Q', b'\x00\x00' + binary[2:8])[0]
    string = f'S-{version}-{authority}'
    binary = binary[8:]
    assert len(binary) == 4 * length
    for i in range(length):
        value = struct.unpack('<L', binary[4*i:4*(i+1)])[0]
        string += '-%d' % value
    return string


print(convert(b64decode(sys.argv[1].encode())))
