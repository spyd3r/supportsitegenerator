#!/usr/bin/env ruby
require 'rubygems'
require 'optparse'

options = {}
optparse = OptionParser.new do |opts|
  opts.on('-h', '--help', 'Help') do
    puts opts
    exit
  end
  opts.on('-a', '--app APPLICATION', 'Application to delete') do |app|
    options[:app] = app
  end
end
optparse.parse!

if ! options[:app].nil?
  rails_app = options[:app]
  puts "Deleting #{rails_app}..."
  sleep 1
  system ("rm -rf /opt/rails/#{rails_app}")
  puts "Stopping web application server if running"
  system("ps -ef |grep thin| grep -v grep |awk '{print $2}'|while read pid; do kill -15 $pid; done")
  puts "Deleting #{rails_app} databases..."
  sleep 1
  system("psql -U postgres -c \"drop database #{rails_app}_production;\"")
  system("psql -U postgres -c \"drop database #{rails_app}_development;\"")
  system("psql -U postgres -c \"drop database #{rails_app}_test;\"")
  puts "Deleting #{rails_app} database user..."
  sleep 1
  system("psql -U postgres -c \"drop role #{rails_app};\"")
else
  system("#{$0} -h")
end
