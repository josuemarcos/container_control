class ContainersController < ApplicationController


  def index
    container = Container.first
    if container
      render json: container
    else
      render json: { error: "Nenhum container encontrado" }, status: :not_found
    end
  end
  

end
