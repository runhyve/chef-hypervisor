default['hypervisor']['packages'] = %w[webhook gotty jo jq bash dnsmasq gnu-ipcalc git netdata nginx qemu-utils pwgen ts grub2-bhyve uefi-edk2-bhyve vm-bhyve]
default['hypervisor']['runhyve_prefix'] = '/opt/runhyve'
default['hypervisor']['repo']['vm-bhyve'] = 'https://github.com/runhyve/vm-bhyve.git'
default['hypervisor']['repo']['vm-webhooks'] = 'https://gitlab.com/runhyve/vm-webhooks.git'
default['hypervisor']['runhyve']['cloud-images'] = [
'http://ftp.freebsd.org/pub/FreeBSD/releases/VM-IMAGES/11.2-RELEASE/amd64/Latest/FreeBSD-11.2-RELEASE-amd64.raw.xz',
'https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-uefi1.img'
]
default['hypervisor']['use_xip'] = false
default['hypervisor']['http_host'] = node['hypervisor']['use_xip'] ? "#{node['ipaddress']}.xip.io" : "#{node['fqdn']}"

default['hypervisor']['tls'] = false
default['hypervisor']['tls_cert'] = '/etc/ssl/selfsigned.crt'
default['hypervisor']['tls_key'] = '/etc/ssl/selfsigned.key'
