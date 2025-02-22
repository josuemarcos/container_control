class ContainersController < ApplicationController
  before_action :set_container


  def index
    container = Container.all
    if container
      render json: container
    else
      render json: { error: "Nenhum container encontrado" }, status: :not_found
    end
  end


  def show
    if @container
      render json: @container
    else
      render json: {error: "Contact not found"}
    end

  end

  
  

  def create
    container = Container.new(container_params)

    if container.save!
      render json: container, status: :created, location: container
      
    else
      render json: container.erros, status: :unprocessable_entity
    end
  end

  def update
    if @container.update(container_params)
      render json: @container
    else
      render json: @container.errors, status: :unprocessable_entity
    end
    
  end

  private

  def container_params
    params.require(:container).permit(:name, :image, :status)
    
  end

  def set_container
    @container = Container.find(params[:id])
    
  end
  
  
  

end
