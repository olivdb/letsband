module BandsHelper
	def band_image_size(band, style)
		width = band.image_width
		height = band.image_height
		
		if style == :medium
			max_size = Band::MEDIUM_IMAGE_RESOLUTION.split('x').map(&:to_i)
		elsif style == :thumb
			max_size = Band::THUMB_IMAGE_RESOLUTION.split('x').map(&:to_i)
		end
		max_width = max_size[0]
		max_height = max_size[1]

		# if no size recorded, use the default image size
		width ||= 540#max_width
		height ||= 303#max_height

		ratio = width*1.0/height

		style_width = ((ratio >= 1.0) ? max_width : (max_height * ratio)).round(0)
		style_height = ((ratio <= 1.0) ? max_height : (max_width / ratio)).round(0)
		"#{style_width}x#{style_height}"
	end
end
