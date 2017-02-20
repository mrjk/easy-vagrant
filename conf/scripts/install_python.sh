#!/bin/bash

# This script will test the presence of python and try to install 
# it. This should work on most of common OSes.

test -e /usr/bin/python || ( \
  (apt -qqy update && apt install -qy python) || \
  (apt -y update && apt install -y python) || \
  (yum install -y python python-simplejson ) || \
  ( dnf install -y python python-simplejson ) )
