class ContainersController < ApplicationController
  #before_action :set_container, only: %i[ show update destroy]
  require 'docker'


  def index
    container = Container.all
    if container
      render json: container
    else
      render json: { error: "Nenhum container encontrado" }, status: 404
    end
  end


  def show
    if @container
      render json: @container
    else
      render json: {error: "Container not found"}
    end
  end

  
  def create
    container = Docker::Container.create(
      'Image'=> params[:image],
      'Cmd' => ['bash', '-c', 'while true; do sleep 10; done']
    )

    @container = Container.create!(
      name: params[:name],
      image: params[:image],
      docker_id: container.id,
      status: 'running')

    if @container.save!
      render json: @container, status: 200
      
    else
      render json: { error: "Container couldn't be created!" }, status: 422
    end

  end

  def update

    if @container.update(container_params)
      render json: @container
    else
      render json: @container.errors, status: 422
    end
    
  end

  def destroy
    if @container
      @container.destroy!
    else
      render json: {error: "Container not found!"}, status: 404
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
