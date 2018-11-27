require 'spec_helper'

describe file('/opt/runhyve/vm-bhyve/vm') do
  it { should be_executable }
end

describe file('/usr/local/etc/vm-webhooks.json') do
  it { should be_linked_to '/opt/runhyve/vm-webhooks/vm-webhooks.json' }
end

describe file('/usr/local/etc/nginx/.runhyvetoken') do
  it { should be_file }
  it { should be_mode 600 }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end

describe service('webhook') do
  it { should be_running }
  it { should be_enabled }
end

describe command("fetch http://vm-webhook.#{host_inventory['ohai']['ipaddress']}.xip.io") do
  its(:stderr) { should match /Forbidden/ }
end

describe port(9090) do
  it { should be_listening }
  it { should be_listening.with('tcp') }
  it { should be_listening.on('127.0.0.1') }
end

describe port(19999) do
  it { should be_listening }
  it { should be_listening.with('tcp') }
  it { should be_listening.on('127.0.0.1') }
end

describe service('dnsmasq') do
  it { should be_running }
  it { should be_enabled }
end

describe service('netdata') do
  it { should be_running }
  it { should be_enabled }
end

describe command('sysctl -n net.inet.ip.forwarding') do
  its(:stdout) { should eq "1\n" }
  its(:exit_status) { should eq 0 }
end

describe zfs('zroot') do
  it { should exist }
end

describe file('/zroot/vm/.config') do
  it { should be_directory }
end

describe file('/zroot/vm/.config/dnsmasq') do
  it { should be_directory }
end

describe file('/zroot/vm/.config/pf-nat') do
  it { should be_directory }
end
