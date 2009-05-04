require 'arinit'
puts "Migrating database #{Time.now}"
ActiveRecord::Migrator.migrate "migrations"
