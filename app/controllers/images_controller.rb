class ImagesController < ApplicationController

  def index
    images = Image.all
    if images.empty?
      render json: { error: "No image found!" }, status: 404
      
    else
      render json: images
    end
  end

end
