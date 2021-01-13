#!/bin/sh

CHEF_VERSION=16.9.20
CHEF_URL="https://packages.chef.io/files/stable/chef/${CHEF_VERSION}/freebsd/12/chef-${CHEF_VERSION}_1.amd64.sh"

if [ "$(id -u)" != 0 ]; then
  echo "Error: This script needs root permissions"
  exit 2
fi

if ! which chef-solo > /dev/null; then
  echo "Hello!
I'm going to download and launch Chef's installation script from
$CHEF_URL
Press ^c to abort if If you want to inspect it first. Sleeping for 5 seconds...
"

  sleep 5
  fetch "$CHEF_URL"
  sh chef-${CHEF_VERSION}_1.amd64.sh
fi

if [ ! -d ./cookbooks/chef_zfs ]; then
  git clone https://github.com/chef-cookbooks/chef_zfs.git ./cookbooks/chef_zfs
else
  (cd ./cookbooks/chef_zfs; git pull --ff-only)
fi

chef-solo -c solo.rb -j hypervisor.json
