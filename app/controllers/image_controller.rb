class ImageController < ApplicationController
  def index

  	require 'chunky_png'

	images = [
	ChunkyPNG::Image.from_file('./public/default.png'),
	ChunkyPNG::Image.from_file('./public/deform.png'),
	ChunkyPNG::Image.from_file('./public/broken_track.png')
	]


	diff = []
	coun_arr = 0
	base_image = images[0] 
	@total = []
	@pixels_changed = []
	@image_changed = []

		images[1,images.size-1].each do | image|

			base_image_height = base_image.height
			base_image_width = base_image.width	
			output = ChunkyPNG::Image.new(base_image_width, image.width, ChunkyPNG::Color::WHITE)

			base_image_height.times do |y|
				base_image.row(y).each_with_index do |pixel, x|
				    if pixel != image[x,y]
				      score = Math.sqrt(
				        (ChunkyPNG::Color.r(image[x,y]) - ChunkyPNG::Color.r(pixel)) ** 2 +
				        (ChunkyPNG::Color.g(image[x,y]) - ChunkyPNG::Color.g(pixel)) ** 2 +
				        (ChunkyPNG::Color.b(image[x,y]) - ChunkyPNG::Color.b(pixel)) ** 2
				      ) / Math.sqrt(255 ** 2 * 3)

				      image[x,y] = ChunkyPNG::Color.grayscale(255 - (score * 255).round)
				      diff << score
				     
				    end  # End of unless
				  end
			 end 

			 @total.push(base_image.pixels.length)
			 @pixels_changed.push(diff.length)
			 @image_changed.push((diff.inject {|sum, value| sum + value} / base_image.pixels.length) * 100)			
			 #puts "Title=====#{image.metadata['Title'] }"
			 image.save("./public/#{coun_arr}_diff.png")

			coun_arr = coun_arr+1
			output = ""

		end 

	
  end
end
