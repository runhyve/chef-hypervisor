#!/bin/sh

if [ "$(id -u)" != 0 ]; then
  echo "Error: This script needs root permissions"
  exit 2
fi

if ! which chef-solo > /dev/null; then
  fetch  https://packages.chef.io/files/stable/chef/14.7.17/freebsd/11/chef-14.7.17_1.amd64.sh
  sh chef-14.7.17_1.amd64.sh
fi
chef-solo -c solo.rb -j hypervisor.json
