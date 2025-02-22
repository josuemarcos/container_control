class Container < ApplicationRecord
  validates :docker_id, presence: true, uniqueness: true
  validates :image, presence: true
  validates :status, presence: true
end
