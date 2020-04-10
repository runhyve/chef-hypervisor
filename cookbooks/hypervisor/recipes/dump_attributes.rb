# This recipe dump attributes to file so that serverspec could
# could use them to perform tests
require 'json'

dump_f = '/var/run/runhyve/node.json'

file dump_f do
  owner 'root'
  mode 0400
end

ruby_block 'save_attributesr' do
  block do

    attributes = node.merged_attributes
    File.open(dump_f, 'w') { |file| file.write(JSON.pretty_generate(attributes)) }
  end
end
