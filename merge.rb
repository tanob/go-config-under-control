#!/bin/env ruby

require 'timeout'
require 'bundler'
Bundler.require

config_file = '/etc/go/cruise-config.xml'

config = Nokogiri::XML(File.open(config_file))
new_config = Nokogiri::XML(File.open('cruise-config.xml'))

(config/:pipelines).remove
config.at('cruise/server').after new_config/:pipelines

server_log = File.open('/var/log/go-server/go-server.log')
server_log.seek 0, IO::SEEK_END

File.open(config_file, 'w') {|f| f.write(config) }

logs = []
begin
Timeout::timeout(30) do
        loop do
                result = select([server_log])
                unless server_log.eof?
                        line = server_log.gets
                        logs << line if line =~ /cachedCruiseConfigRefreshExecutorThread/
                        break if line =~ /Configuration Changed/
                end
        end
end
ensure
	puts logs.join("\n")
end

