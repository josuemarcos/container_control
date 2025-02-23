class Container < ApplicationRecord
  validates :docker_id, presence: true, uniqueness: true
  validates :image, presence: true
  validates :status, presence: true

  def self.create_docker_container(name, image)

    container = Docker::Container.create(
    'Image' => image,
    'name' => name,
    'Cmd' => ['bash', '-c', 'while true; do sleep 10; done']
    )
  end

  def self.start_container(docker_id)
    docker_container = Docker::Container.get(docker_id)
    docker_container.start
  end

  def self.stop_container(docker_id)
    docker_container = Docker::Container.get(docker_id)
    docker_container.stop
  end

  def self.delete_container(docker_id)
    docker_container = Docker::Container.get(docker_id)
    docker_container.delete(:force => true)
  end

end
