require 'serverspec'
require 'json'

set :backend, :exec

$node = ::JSON.parse(File.read('/var/run/runhyve/node.json'))
