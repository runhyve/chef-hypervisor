default['hypervisor']['packages'] = %w[webhook ttyd jo jq bash dnsmasq gnu-ipcalc git netdata nginx qemu-utils pwgen ts grub2-bhyve uefi-edk2-bhyve uefi-edk2-bhyve-csm vm-bhyve cdrkit-genisoimage dmidecode]
default['hypervisor']['runhyve_prefix'] = '/opt/runhyve'
default['hypervisor']['repo']['vm-webhooks'] = 'https://gitlab.com/runhyve/vm-webhooks.git'
default['hypervisor']['runhyve']['cloud-images'] = [
'http://ftp.freebsd.org/pub/FreeBSD/releases/VM-IMAGES/11.2-RELEASE/amd64/Latest/FreeBSD-11.2-RELEASE-amd64.raw.xz',
'https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-uefi1.img'
]
default['hypervisor']['use_xip'] = false
default['hypervisor']['http_host'] = node['hypervisor']['use_xip'] ? "#{node['ipaddress']}.xip.io" : "#{node['fqdn']}"

default['hypervisor']['tls']['enable'] = false
default['hypervisor']['tls']['generate_selfsigned'] = false
default['hypervisor']['tls']['cert'] = '/etc/ssl/selfsigned.crt'
default['hypervisor']['tls']['key'] = '/etc/ssl/selfsigned.key'
default['hypervisor']['lego_version'] = '2.5.0'
