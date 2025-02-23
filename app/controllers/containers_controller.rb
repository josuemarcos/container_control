class ContainersController < ApplicationController
  before_action :set_container, only: %i[ show update destroy change_status]
  before_action :set_docker_container, only: %i[destroy change_status]
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
  
    container = Container.create_docker_container(params[:name], params[:image])

    @container = Container.create!(
      name: params[:name],
      image: params[:image],
      docker_id: container.id,
      status: 'stopped')

    render json: @container, status: 200

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

  def change_status

    if params[:status].capitalize == "Start"
      if check_container_status(@container)
        render json: {error: "This container is already running!"}, status: 400
        
      else !check_container_status(@container)
        @docker_container.start
        @container[:status] = "Running"
        render json: @container, status: 200
      end
      
    elsif params[:status].capitalize == "Stop"
      if check_container_status(@container)
        @docker_container.stop
        @container[:status] = "Stopped"
        render json: @container, status: 200
          
      else !check_container_status(@container)
        render json: {error: "This container is already stopped!"}, status: 400
        
      end


    else 
      render json: {error: "Invalid option!"}, status: 400

    end

    rescue Docker::Error::DockerError => e
      render json: {error: e.message}, status: 422

  end
  

  def destroy
    if @container
      @docker_container.delete(:force => true)
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

  def set_docker_container
    @docker_container = Docker::Container.get(@container.docker_id)
  end

  def check_container_status(container)
    container[:status].capitalize == "Start" ? true : false
    
  end
  
  
  
  
  

end
