class AddImageToContainers < ActiveRecord::Migration[7.2]
  def change
    add_reference :containers, :image, foreign_key: true
  end
end
