#!/bin/sh

./install-wo-githooks.sh
git checkout -b $(cat /proc/sys/kernel/hostname | awk '{print tolower($0)}')
