#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

if sys.version_info >= (3, 11):
    import tomllib as tomli
else:
    import tomli

if __name__ == '__main__':
    """
    Simply print the dependencies delimited with commas.
    """
    with open('Pipfile', mode='rb') as f:
        pipfile = tomli.load(f)
        print(','.join(pipfile['packages'].keys()))
