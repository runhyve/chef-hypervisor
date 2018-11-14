default['hypervisor']['packages'] = %w[webhook gotty jo jq bash dnsmasq gnu-ipcalc git netdata]
default['hypervisor']['runhyve_prefix'] = '/opt/runhyve'
default['hypervisor']['repo']['vm-bhyve'] = 'https://github.com/runhyve/vm-bhyve.git'
default['hypervisor']['repo']['vm-webhooks'] = 'https://gitlab.com/runhyve/vm-webhooks.git'
