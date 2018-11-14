chef_gem 'serverspec'

node['hypervisor']['packages'].each do |pkg|
  package pkg
end

directory node['hypervisor']['runhyve_prefix'] do
  user 'root'
  group 'wheel'
  mode '0755'
  action :create
end

git "#{node['hypervisor']['runhyve_prefix']}/vm-bhyve" do
  repository node['hypervisor']['repo']['vm-bhyve']
  revision 'master'
  action :sync
end


git "#{node['hypervisor']['runhyve_prefix']}/vm-webhooks" do
  repository node['hypervisor']['repo']['vm-webhooks']
  revision 'master'
  action :sync
end

link '/usr/local/etc/vm-webhooks.json' do
  to '/opt/runhyve/vm-webhooks/vm-webhooks.json'
end

service 'nginx' do
  action [:enable, :start]
end

service 'webhook' do
  subscribes :restart, 'file[/usr/local/etc/vm-webhooks.json]', :immediately
  subscribes :restart, 'file[/opt/runhyve/vm-webhooks/vm-webhooks.json]', :immediately
  action [:enable, :start]
end

service 'dnsmasq' do
  action [:enable, :start]
end

service 'netdata' do
  action [:enable, :start]
end
