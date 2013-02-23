#!/bin/env ruby

require 'bundler'
Bundler.require

config_file = '/etc/go/cruise-config.xml'

config = Nokogiri::XML(File.open(config_file))
new_config = Nokogiri::XML(File.open('cruise-config.xml'))

(config/:pipelines).remove
config.at('cruise') << new_config/:pipelines

File.open(config_file, 'w') {|f| f.write(config) }

