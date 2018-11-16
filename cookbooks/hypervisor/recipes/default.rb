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

file "#{node['hypervisor']['runhyve_prefix']}/vm-bhyve/vm" do
  mode '0755'
end

git "#{node['hypervisor']['runhyve_prefix']}/vm-webhooks" do
  repository node['hypervisor']['repo']['vm-webhooks']
  revision 'master'
  action :sync
  notifies :restart, 'service[webhook]', :immediately
end

link '/usr/local/etc/vm-webhooks.json' do
  to '/opt/runhyve/vm-webhooks/vm-webhooks.json'
end

service 'webhook' do
  subscribes :restart, 'file[/usr/local/etc/vm-webhooks.json]', :immediately
  subscribes :restart, 'file[/opt/runhyve/vm-webhooks/vm-webhooks.json]', :immediately
  action [:enable, :start]
end

directory '/usr/local/etc/nginx/' do
  owner 'root'
  group 'wheel'
  mode '0755'
end

template '/usr/local/etc/nginx/nginx.conf' do
  owner 'root'
  group 'wheel'
  mode '0644'
  notifies :restart, 'service[nginx]', :immediately
end

service 'nginx' do
  action [:enable, :start]
end

template '/etc/rc.conf.local' do
  owner 'root'
  group 'wheel'
  mode '0640'
  notifies :restart, 'service[webhook]', :immediately
end

%w[dnsmasq pf-nat pf-security].each do |dir|
  directory "/zroot/vm/.config/#{dir}/" do
    owner 'root'
    group 'wheel'
    mode '0750'
    recursive true
  end
end

template '/usr/local/etc/dnsmasq.conf' do
  owner 'root'
  group 'wheel'
  mode '0640'
  notifies :restart, 'service[dnsmasq]', :immediately
end

service 'dnsmasq' do
  action [:enable, :start]
end

service 'netdata' do
  action [:enable, :start]
end

service 'sysctl'

template '/etc/sysctl.conf.local' do
  owner 'root'
  group 'wheel'
  mode '0640'
  notifies :restart, 'service[sysctl]', :immediately
end

directory '/zroot/vm/.templates' do
  owner 'root'
  group 'wheel'
  mode '0750'
end

%w[freebsd-1C-1024MB-50HDD.conf ubuntu-1C-1024MB-50HDD.conf].each do |template|
  template "/zroot/vm/.templates/#{template}" do
    owner 'root'
    group 'wheel'
    mode '0644'
  end
end
