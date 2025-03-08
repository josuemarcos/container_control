class ContainersController < ApplicationController
  before_action :set_container, only: %i[ show destroy change_status]
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
      docker_container = Docker::Container.get(@container.docker_id)
    else
      render json: {error: "Container not found"}
    end
  end

  
  def create
    image = Image.find(params[:image_id])
    container = Container.create_docker_container(params[:name], image.name)
    @container = Container.create!(
    name: params[:name],
    image: image,
    docker_id: container.id,
    status: 'stopped')
    render json: @container, status: 200

    rescue ActiveRecord::RecordInvalid => e
    render json: {error: e.message}, status: 422

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
    if @container
      Container.delete_container(@container.docker_id)
      @container.destroy!
    else
      render json: {error: "Container not found!"}, status: 404
    end

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

  
  
  
  
  
  

end
