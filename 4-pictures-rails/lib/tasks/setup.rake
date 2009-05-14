desc "Perform initial setup of the Pictures app"
task :setup => ["db:migrate", "sample_data:load"] 

task :rebuild => ['sample_data:remove_images', 'sample_data:delete_thumbnails', 'db:reset', :setup]