unless $start_time
  $start_time = Time.now
  puts "Perf: server starting #{$start_time}"
end

require 'rubygems'
require 'sinatra'

get '/' do
  @msg1 = 'Hello'
  @msg2 = 'World'
  erb 'IronRuby running Sinatra says "<%= @msg1 %>, <b><%= @msg2 %></b>" at <%= Time.now %>'
end
