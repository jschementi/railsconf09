require 'resizer'

size = 640
file = 'fel.jpg'
new_file = file.split('.').first + "_" + size.to_s + '.' + file.split('.').last

puts "Resizing \"#{file}\" to \"#{new_file}\""

puts "Clean up"

File.delete new_file if File.exist? new_file

puts "Reading #{file} into memory"

input = FileStream.new file, FileMode.open
reader = BinaryReader.new input
input_bytes = reader.ReadBytes(input.length)
reader.close
input.close

puts "Resizing"
output_bytes = resize_image input_bytes, size

puts "Outputing #{new_file}"

output = FileStream.new new_file, FileMode.create_new
writer = BinaryWriter.new output
writer.write output_bytes
writer.close
output.close

puts "Done"
