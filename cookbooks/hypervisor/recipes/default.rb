chef_gem 'serverspec'

chef_zfs node['hypervisor']['zfs']['filesystem'] do
  properties [
    { mountpoint: "#{node['hypervisor']['zfs']['mountpoint']}" },
    { compression: 'lz4' },
    { atime: 'off' }
  ]
  action :create
end

node['hypervisor']['packages'].each do |pkg|
  package pkg
end

directory node['hypervisor']['runhyve_prefix'] do
  user 'root'
  group 'wheel'
  mode '0755'
  action :create
end

git "#{node['hypervisor']['runhyve_prefix']}/vm-webhooks" do
  repository node['hypervisor']['repo']['vm-webhooks']
  revision 'master'
  action :sync
  notifies :restart, 'service[webhook]', :immediately
end

remote_file "#{node['hypervisor']['runhyve_prefix']}/lego-v#{node['hypervisor']['lego_version']}.tgz" do
  source "https://github.com/xenolf/lego/releases/download/v#{node['hypervisor']['lego_version']}/lego_v#{node['hypervisor']['lego_version']}_freebsd_amd64.tar.gz"
  owner 'root'
  group 'wheel'
  notifies :run, 'bash[extract-lego]', :immediately
end

bash 'extract-lego' do
  cwd node['hypervisor']['runhyve_prefix']
  code <<-EOH
    tar zxvf #{node['hypervisor']['runhyve_prefix']}/lego-v#{node['hypervisor']['lego_version']}.tgz
  EOH
  action :nothing
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

directory '/var/run/runhyve/' do
  owner 'root'
  group 'wheel'
  mode '0750'
end

ruby_block 'generate_random_token' do
  block do
    require 'securerandom'
    token = SecureRandom.uuid
    File.write('/usr/local/etc/nginx/.runhyvetoken', token)
  end
  not_if { File.exist?('/usr/local/etc/nginx/.runhyvetoken') }
end

file '/usr/local/etc/nginx/.runhyvetoken' do
  owner 'root'
  group 'wheel'
  mode '0600'
end

openssl_x509_certificate node['hypervisor']['tls']['cert'] do
  key_file node['hypervisor']['tls']['key']
  common_name node['hypervisor']['http_host']
  expire 365
  subject_alt_name ["IP:#{node['ipaddress']}", "DNS:*.#{node['fqdn']}"]
  notifies :restart, 'service[nginx]', :immediately
  only_if { node['hypervisor']['tls']['enable'] && node['hypervisor']['tls']['generate_selfsigned'] }
end

template '/usr/local/etc/nginx/tls-nginx-fixture.conf' do
  owner 'root'
  group 'wheel'
  mode '0600'
  notifies :restart, 'service[nginx]', :immediately
end

template '/usr/local/etc/nginx/nginx.conf' do
  owner 'root'
  group 'wheel'
  mode '0600'
  notifies :restart, 'service[nginx]', :immediately
end

service 'nginx' do
  action [:enable, :start]
end

service 'random'
service 'kld'

template '/etc/rc.conf.local' do
  owner 'root'
  group 'wheel'
  mode '0640'
  notifies :restart, 'service[webhook]', :immediately
  notifies :restart, 'service[random]', :immediately
  notifies :restart, 'service[kld]', :immediately
end

execute 'vm-init' do
  command 'vm init'
  creates "#{node['hypervisor']['zfs']['mountpoint']}"
end

%w[dnsmasq pf-nat pf-security].each do |dir|
  directory "#{node['hypervisor']['zfs']['mountpoint']}/.config/#{dir}/" do
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

directory "#{node['hypervisor']['zfs']['mountpoint']}/.templates" do
  owner 'root'
  group 'wheel'
  mode '0750'
end

%w[bhyveload.conf grub.conf uefi-csm.conf].each do |template|
  template "#{node['hypervisor']['zfs']['mountpoint']}/.templates/#{template}" do
    owner 'root'
    group 'wheel'
    mode '0644'
  end
end

include_recipe '::dump_attributes'
