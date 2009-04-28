require 'mscorlib'
require 'System'
require 'System.Drawing'

include System
include System::Drawing
include System::Drawing::Drawing2D
include System::Drawing::Imaging
include System::IO

def resize_image image_bytes, target_size
    original = Image.from_stream MemoryStream.new(image_bytes)
    
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

    # Create a new blank canvas.  The resized image will be drawn on this canvas.
    bm = Bitmap.new target_width, target_height, PixelFormat.Format24bppRgb
    bm.set_resolution 72, 72
    gr = Graphics.from_image bm
    gr.SmoothingMode = SmoothingMode.AntiAlias
    gr.InterpolationMode = InterpolationMode.HighQualityBicubic
    gr.PixelOffsetMode = PixelOffsetMode.HighQuality
    gr.draw_image img, Rectangle.new(0, 0, target_width, target_height), 
      0, 0, original.width, original.height, GraphicsUnit.Pixel
    
    # Save out to memory and then to a file.
    # We dispose of all objects to make sure the files don't stay locked.
    mm = MemoryStream.new
    bm.save mm, ImageFormat.Jpeg
    
    original.dispose
    img.dispose
    bm.dispose
    gr.dispose

    mm.get_buffer
end
