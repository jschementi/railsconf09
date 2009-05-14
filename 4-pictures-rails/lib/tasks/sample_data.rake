require 'erb'
require 'fileutils'

namespace :sample_data do

  desc "Remove images"
  task :remove_images => :environment do
    puts "Removing images"
    Picture.destroy_all
  end

  desc "Delete thumbnails"
  task :delete_thumbnails => :environment do
    puts "Deleting Thumbnails"
    Dir.entries("sample_data/albums").each do |album_name|
      Dir.glob("sample_data/albums/#{album_name}/*.jpg").each do |image|
        ::File.delete image if image.include? "_small"
      end
    end
  end

  desc "Generate thumbnails"
  task :generate_thumbnails => :environment do
    puts "Generating thumbnails"
    require RAILS_ROOT + '/../6-resizer/resizer'
    require 'ftools'
    Dir.entries("sample_data/albums").each do |album_name|
      Dir.glob("sample_data/albums/#{album_name}/*.jpg").each do |image|
        next if image.include? "_small.jpg"
        image.gsub!(/\.JPG/, ".jpg")
        small_name = image.gsub(/\.jpg/, "_small.jpg")
        max_thumb_size = 144
        max_side = 1280

        unless ::File.exist? small_name
          puts "Creating square thumbnail for #{image}"
          Resizer::resize_by_filename image, small_name, max_thumb_size
          Resizer::center_square_file small_name, small_name, true # overwrite
        end

        width, height = Resizer::image_dimensions(image)

        if width > max_side || height > max_side
          puts "#{image} too large, sizing down to #{max_side}"
          Resizer::resize_by_filename image, image, max_side, true # overwrite
        end
      end
    end
  end

  desc "Load sample data from sample_data/ fixture files into the current 
        environment's database.  Load specific fixtures using FIXTURES=x,y"
  task :load => [:environment, "db:migrate", :generate_thumbnails] do
    require 'digest'
    require RAILS_ROOT + '/../6-resizer/resizer'

    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

    Dir.glob(File.join(RAILS_ROOT, 'sample_data', '*.{yml}')).each do |ff|
      data_file = File.join(RAILS_ROOT, 'sample_data', File.basename(ff))
      model = File.basename(ff, '.*').camelcase.singularize.constantize
      if File.exists?(data_file)
        File.open(data_file) do |yml| 
          entries = YAML.load(ERB.new(yml.read).result)
          if entries
            entries.each do |_, fields|
              unless model.find_by_id(fields["id"])
                r = model.new fields
                r.save! 
              end
            end
          end
        end
        puts "Loaded #{
          File.basename(ff, '.*').camelcase.singularize.constantize.count
        } #{
          File.basename(ff, '.*').camelcase
        }" rescue nil
      end
    end

    Dir.entries("sample_data/albums").each do |an|
      album = Album.find_by_name(an)
      if album
        Dir.glob("sample_data/albums/#{an}/*.jpg").each do |image|
          next if image.include?("_small")
          puts "Loading #{File.basename(image)} into #{an}"
          
          data = File.open(image, 'rb'){|f| f.read}
          thumbnail_data = File.exist?(image.gsub(/\.jpg/, "_small.jpg")) ?
            File.open(image.gsub(/\.jpg/, "_small.jpg"), "rb") {|f| f.read} :
            ""
          album.pictures.create :title => File.basename(image)[0...-4].humanize,
            :mime_type => "image/jpg",
            :data => data, :thumbnail_data => thumbnail_data,
            :person => album.person, :filename => File.basename(image)
        end
      end
    end
  end

end
