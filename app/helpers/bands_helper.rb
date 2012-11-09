module BandsHelper
  def image_for(band, options = { width: 250 })
    image_tag('myband.jpg', alt: band.name, class: "gravatar", width: options[:width])
  end
end
