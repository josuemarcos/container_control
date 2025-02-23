class AddDockerIdToContainers < ActiveRecord::Migration[7.2]
  def change
    add_column :containers, :docker_id, :string
  end
end
