class ContainerSerializer < ActiveModel::Serializer
  attributes :id, :docker_id, :name, :image, :status, :image_id
end
