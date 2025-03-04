class RemoveCodeFromImage < ActiveRecord::Migration[7.2]
  def change
    remove_column :images, :code, :string
  end
end
