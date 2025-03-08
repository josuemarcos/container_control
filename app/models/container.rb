class Container < ApplicationRecord
  validates :docker_id, presence: true, uniqueness: true
  validates :image, presence: true
  validates :status, presence: true
  belongs_to :image

  def self.create_docker_container(name, image)

    #Checks if the selected image exists in local storage and download it from docker hub if it can't find it
    Docker::Image.create('fromImage' => image)

    #Create a new docker container with the provided params
    container = Docker::Container.create(
    'Image' => image,
    'name' => name,
    'Cmd' => ['bash', '-c', 'while true; do sleep 10; done']
    )
  end

  def self.change_status(container, docker_id, status)
    return { error: "Container not found!", status: 404 } unless container
    if status == "Start"
      if check_container_status(container)
        return  {error: "This container is already running!", status: 400}
      else
        docker_container = Docker::Container.get(docker_id)
        docker_container.start
        container[:status] = "Running"
        container.save!
        return  {container: container, status: 200}
      end
    elsif status == "Stop"
      if check_container_status(container)
        docker_container = Docker::Container.get(docker_id)
        docker_container.stop
        container[:status] = "Stopped"
        container.save!
        return  {container: container, status: 200}
      else
        return  {error: "This container is already stopped!", status: 400}
      end
    else
      return  {error: "Invalid option!", status: 400}
    end
  end
  
  def self.delete_container(docker_id)
    docker_container = Docker::Container.get(docker_id)
    docker_container.delete(:force => true)
  end

  def self.check_container_status(container)
    container[:status].capitalize == "Running" ? true : false
  end
  
end