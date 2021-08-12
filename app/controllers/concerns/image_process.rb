module ImageProcess
  extend ActiveSupport::Concern
  def load_image(file)
    image = MiniMagick::Image.open(file)
    MiniMagick::Image.read(image)
  end

  def pixels_array(image, width, height)
    image.resize("#{width}x#{height}")
    pixels = image.get_pixels
    pixels_array = []
    for x in 0..(height - 1) do
      for y in 0..(width - 1) do
        if pixels[x] and pixels[x][y]
          pixels_array << [pixels[x][y][0], pixels[x][y][1], pixels[x][y][2]]
        else
          pixels_array << [0,0,0]
        end
      end
    end
    pixels_array.flatten
  end
end