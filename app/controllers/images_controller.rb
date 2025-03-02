class ImagesController < ApplicationController

  def index
    images = Image.all
    if images
      render json: images
    else
      render json: { error: "No image found!" }, status: 404
    end
  end

end
