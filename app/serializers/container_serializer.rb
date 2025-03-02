class ContainerSerializer < ActiveModel::Serializer
  attributes :id, :docker_id, :name, :image, :status

  belongs_to :image
end
