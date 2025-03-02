class ImageSerializer < ActiveModel::Serializer
  attributes :id, :name 

  has_many :containers
end
