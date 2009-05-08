$start_time = Time.now
puts "Perf: server starting #{$start_time}"

require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/app'

run Sinatra::Application
