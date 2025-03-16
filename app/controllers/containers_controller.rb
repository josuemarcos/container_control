class ContainersController < ApplicationController
  before_action :set_container, only: %i[ show destroy change_status]
  require 'docker'
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid


  def index
    container = Container.all
    if container.empty?
      render json: { error: "No container found!" }, status: 404
    else
      render json: container
    end
  end


  def show
    render json: @container
    docker_container = Docker::Container.get(@container.docker_id)
  end

  
  def create
    image = Image.find(params[:image_id])
    container = Container.create_docker_container(params[:name], image.name)
    @container = Container.create(
    name: params[:name],
    image: image,
    docker_id: container.id,
    status: 'stopped')
    render json: @container, status: 200

    rescue Docker::Error::DockerError => e
    render json: {error: e.message}, status: 422
  end

 


  def change_status
    status = params[:status].capitalize
    result = Container.change_status(@container, @container.docker_id, status)
  
    render json: result[:container] || { error: result[:error] }, status: result[:status]
  
    rescue Docker::Error::DockerError => e
      render json: { error: e.message }, status: 422

  end
  

  def destroy
    Container.delete_container(@container, @container.docker_id)
    render status: 204

    rescue Docker::Error::DockerError => e
    render json: {error: e.message}, status: 422
  end



  private

  def container_params
    params.require(:container).permit(:name, :image, :status)
  end

  def set_container
    @container = Container.find(params[:id])
  end

  def invalid(error)
    render json: {error: error.message}, status: 422
  end

  def not_found(error)
    render json: {error: error.message}, status: 404
    
  end
  

  
  
  
  
  
  

end
