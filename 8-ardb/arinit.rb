puts "Loading rubygems #{Time.now}"
require 'rubygems'

puts "Loading activerecord #{Time.now}"
require 'activerecord'

puts "Connecting to database #{Time.now}"
ActiveRecord::Base.establish_connection(
  :adapter => "mssql",
  :host    => "JIMMYSCH-GEMINI\\SQLEXPRESS",
  :database => "ardb",
  :integrated_security => true
)

ActiveRecord::Base.logger = Logger.new("activerecord.log")
