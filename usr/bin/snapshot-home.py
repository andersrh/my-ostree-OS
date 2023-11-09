#!/usr/bin/python3 -u

import os
import datetime

stream = os.popen('btrfs subvolume snapshot /var/home /var/.snapshot.home/' + datetime.datetime.now().strftime("%Y.%m.%d_%H:%M:%S") + '/')
output = stream.read()
print(output)
