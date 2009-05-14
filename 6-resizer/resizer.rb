module Resizer
  require 'mscorlib'
  require 'System'
  require 'System.Drawing'

  include System
  include System::Drawing
  include System::Drawing::Drawing2D
  include System::Drawing::Imaging
  include System::IO

  def self.center_square_file(old_filename, new_filename, overwrite = false)
    if !overwrite && ::File.exist?(new_filename)
      raise "#{new_filename} already exists"
    end

    write_bytes_to(new_filename) do
      processed_bytes = read_bytes_from(old_filename) do |bytes|
        center_square bytes
      end

      # delete the new file now, just in case it 
      # is the same as the old file
      ::File.delete(new_filename) if overwrite && ::File.exist?(new_filename)

      processed_bytes
    end
    nil
  end

  def self.center_square image_bytes
    img = Image.from_stream MemoryStream.new(image_bytes)

    l = lambda{ |long, cube| (long - cube) / 2 }
    dimensions = [:width, :height]
    cubeside = img.width > img.height ? dimensions.last : dimensions.first
    longside = dimensions.find{|i| i != cubeside}
    index = cubeside == :width ? 1 : 0
    cubesize = img.send(cubeside)
    txty = [0, 0]
    txty[index] = l[img.send(longside), cubesize]
    tx, ty = txty
    
    img.dispose

    crop image_bytes, cubesize, cubesize, tx, ty
  end
  
  def self.crop image_bytes, targetw, targeth, targetx, targety
    imgPhoto = Image.from_stream MemoryStream.new(image_bytes)

    bmPhoto = Bitmap.new targetw, targeth, PixelFormat.Format24bppRgb
    bmPhoto.SetResolution 150, 150
    
    grPhoto = Graphics.FromImage bmPhoto
    grPhoto.SmoothingMode = SmoothingMode.AntiAlias
    grPhoto.InterpolationMode = InterpolationMode.HighQualityBicubic
    grPhoto.PixelOffsetMode = PixelOffsetMode.HighQuality
    grPhoto.DrawImage imgPhoto, Rectangle.new(0, 0, targetw, targeth),
        targetx, targety, targetw, targeth, GraphicsUnit.Pixel

    # Save out to memory and then to a file.  
    # We dispose of all objects to make sure the files don't stay locked.
    mm = MemoryStream.new
    bmPhoto.Save mm, ImageFormat.jpeg
    imgPhoto.Dispose
    bmPhoto.Dispose
    grPhoto.Dispose

    mm.GetBuffer
  end

  def self.image_dimensions(filename)
    read_bytes_from(filename) do |input_bytes|
      image = Image.from_stream MemoryStream.new(input_bytes)
      retval = [image.width, image.height]
      image.dispose
      retval
    end
  end

  def self.resize_image image_bytes, target_size
    original = Image.from_stream MemoryStream.new(image_bytes)

    # Figure out the target widht/height
    target_width, target_height = if original.height > original.width
      [
        (original.width * (target_size / original.height.to_f)).to_i,
        target_size
      ]
    else
      [
        target_size,
        (original.height * (target_size / original.width.to_f)).to_i
      ]
    end

    img = Image.from_stream MemoryStream.new(image_bytes)

    # Create a new blank canvas.
    # The resized image will be drawn on this canvas.
    bm = Bitmap.new target_width, target_height, PixelFormat.Format24bppRgb
    bm.set_resolution 150, 150
    gr = Graphics.from_image bm
    gr.SmoothingMode = SmoothingMode.AntiAlias
    gr.InterpolationMode = InterpolationMode.HighQualityBicubic
    gr.PixelOffsetMode = PixelOffsetMode.HighQuality
    gr.draw_image img, Rectangle.new(0, 0, target_width, target_height), 
      0, 0, original.width, original.height, GraphicsUnit.Pixel

    # Save out to memory. Dispose of all objects to make 
    # sure the files don't stay locked.
    mm = MemoryStream.new
    bm.save mm, ImageFormat.Jpeg

    original.dispose
    img.dispose
    bm.dispose
    gr.dispose

    mm.get_buffer
  end

  def self.resize_by_filename(old_filename, new_filename, longsize, 
    overwrite = false)
    if !overwrite && ::File.exist?(new_filename)
      raise "#{new_filename} already exists"
    end

    write_bytes_to(new_filename) do
      bytes = resize_by_initial_filename(old_filename, longsize)
      
      # delete the new file now, just in case it is the same as the old file
      ::File.delete(new_filename) if overwrite && ::File.exist?(new_filename)

      bytes
    end
    nil
  end

  def self.resize_by_initial_filename(filename, longsize)
    read_bytes_from(filename) do |input_bytes|
      resize_image input_bytes, longsize
    end
  end
  
  def self.read_bytes_from(filename, &block)
    raise "Must provide a block" unless block_given?

    # Reading file into memory
    input = FileStream.new filename, FileMode.open
    reader = BinaryReader.new input
    input_bytes = reader.read_bytes input.length
    reader.close
    input.close
    block.call(input_bytes)
  end
  
  def self.write_bytes_to(filename, &block)
    raise "Must provide a block" unless block_given?
    output_bytes = block.call

    # Writing new file to disk
    output = FileStream.new filename, FileMode.create_new
    writer = BinaryWriter.new output
    writer.write(output_bytes)
    writer.close
    output.close

    nil
  end
end

# Usage example
if __FILE__ == $0
  if ARGV.size != 2 || ARGV[0].nil? || ARGV[0].empty? || ARGV[1].nil? || ARGV[1].to_i == 0
    return puts("Usage: ir resizer.rb <filename> <long-size>")
  end

  size = ARGV[1].to_i
  file = ARGV[0].to_s
  new_file = file.split('.').first + "_" + size.to_s + '.' + file.split('.').last

  puts "Resizing \"#{file}\" to \"#{new_file}\""
  Resizer::resize_by_filename file, new_file, size, true # overwrite
  Resizer::center_square_file new_file, new_file, true # overwrite
  puts "Done"
end
