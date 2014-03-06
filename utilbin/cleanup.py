#!/usr/bin/env python2
"""
Look for duplicate files in a directory tree.
"""

import sys
import os
import hashlib

def chunk_reader(fobj, chunk_size=1024):
    """Generator that reads a file in chunks of bytes"""
    while True:
        chunk = fobj.read(chunk_size)
        if not chunk:
            return
        yield chunk

def check_for_duplicates(paths, hash=hashlib.sha1):
    hashes = set()
    dupcount = 0
    for path in paths:
        for dirpath, dirnames, filenames in os.walk(path):
            for filename in filenames:
                full_path = os.path.join(dirpath, filename)
                if not full_path.endswith('.emlx'):
                    continue
                hashobj = hash()
                for chunk in chunk_reader(open(full_path, 'rb')):
                    hashobj.update(chunk)
                file_id = '%s%s' % (hashobj.digest(), '')
                if file_id in hashes:
                    dupcount += 1
                    print full_path
                else:
                    hashes.add(file_id)
    print 'Found %s duplicates' % dupcount

usage = """
%s [path list]
Recursively check all paths passed to the script for duplicates, and print the path to the duplicate files to stdout.
"""

if __name__ == "__main__":
    args = sys.argv[1:]
    if len(args):
        if '-h' in args or '--help' in args:
            print usage % sys.argv[0]
        else:
            check_for_duplicates(args)
    else:
        print "Please pass the paths to check as parameters to the script"
