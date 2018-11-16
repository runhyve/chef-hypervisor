default['hypervisor']['packages'] = %w[webhook gotty jo jq bash dnsmasq gnu-ipcalc git netdata nginx qemu-utils]
default['hypervisor']['runhyve_prefix'] = '/opt/runhyve'
default['hypervisor']['repo']['vm-bhyve'] = 'https://github.com/runhyve/vm-bhyve.git'
default['hypervisor']['repo']['vm-webhooks'] = 'https://gitlab.com/runhyve/vm-webhooks.git'
default['hypervisor']['runhyve']['cloud-images'] = [
'http://ftp.freebsd.org/pub/FreeBSD/releases/VM-IMAGES/11.2-RELEASE/amd64/Latest/FreeBSD-11.2-RELEASE-amd64.raw.xz',
'https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-uefi1.img'
]
