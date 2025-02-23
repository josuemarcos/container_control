class ContainersController < ApplicationController
  before_action :set_container, only: %i[ show update destroy]
  require 'docker'


  def index
    container = Container.all
    if container
      render json: container
    else
      render json: { error: "No container found!" }, status: 404
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
      'name' => params[:name],
      'Cmd' => ['bash', '-c', 'while true; do sleep 10; done']
    )

    @container = Container.create!(
      name: params[:name],
      image: params[:image],
      docker_id: container.id,
      status: 'running')

    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.message}, status: 422

    rescue Docker::Error::DockerError => e
      render json: {error: e.message}, status: 422
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
      docker_container = Docker::Container.get(@container.docker_id)
      docker_container.delete(:force => true)
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
