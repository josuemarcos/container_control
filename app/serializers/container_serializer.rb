class ContainerSerializer < ActiveModel::Serializer
  attributes :id, :docker_id, :name, :image, :status
end
