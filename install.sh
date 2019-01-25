#!/bin/sh

CHEF_VERSION=14.9.13

if [ "$(id -u)" != 0 ]; then
  echo "Error: This script needs root permissions"
  exit 2
fi

if ! which chef-solo > /dev/null; then
  fetch  https://packages.chef.io/files/stable/chef/${CHEF_VERSION}/freebsd/11/chef-${CHEF_VERSION}_1.amd64.sh
  sh chef-${CHEF_VERSION}_1.amd64.sh
fi

git clone https://github.com/chef-cookbooks/chef_zfs.git ./cookbooks/chef_zfs
chef-solo -c solo.rb -j hypervisor.json
