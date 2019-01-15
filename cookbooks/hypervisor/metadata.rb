name 'hypervisor'
maintainer 'Mateusz Kwiatkowski'
maintainer_email 'mateusz@runateam.com'
license 'All Rights Reserved'
description 'Configures bhyve hypervisor'
long_description 'Configures bhyve hypervisor'
version '0.1.3'
chef_version '>= 14.7' if respond_to?(:chef_version)

issues_url 'https://gitlab.com/runhyve/chef-hypervisor/issues'
source_url 'https://gitlab.com/runhyve/chef-hypervisor/master'

supports 'freebsd'

depends 'chef_zfs'
