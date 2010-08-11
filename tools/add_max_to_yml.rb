#!/usr/bin/env ruby

require 'yaml'

file = ARGV.shift

output = {}
items = YAML.load_file(file)
items.each { |i| output[i[0]] = { 'id' => i[1], 'max' => 128 } }

puts output.to_yaml
