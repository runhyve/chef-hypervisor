require 'spec_helper'

describe file('/opt/runhyve/vm-bhyve/vm') do
  it { should be_executable }
end

describe file('/usr/local/etc/vm-webhooks.json') do
  it { should be_linked_to '/opt/runhyve/vm-webhooks/vm-webhooks.json' }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end

describe service('webhook') do
  it { should be_running }
  it { should be_enabled }
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
