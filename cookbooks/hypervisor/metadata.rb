name 'hypervisor'
maintainer 'Mateusz Kwiatkowski'
maintainer_email 'mateusz@runateam.com'
license 'BSD'
description 'Configures bhyve hypervisor'
long_description 'Configures bhyve hypervisor'
version '0.1.5'
chef_version '>= 16.9' if respond_to?(:chef_version)

issues_url 'https://gitlab.com/runhyve/chef-hypervisor/issues'
source_url 'https://gitlab.com/runhyve/chef-hypervisor/master'

supports 'freebsd'

depends 'chef_zfs'
