#!/bin/sh
if [ "$(id -u)" != 0 ]; then
  echo "Error: This script needs root permissions"
  exit 2
fi

cd cookbooks/hypervisor
/opt/chef/embedded/bin/rake
