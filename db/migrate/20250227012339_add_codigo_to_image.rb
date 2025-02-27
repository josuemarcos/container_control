class AddCodigoToImage < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :codigo, :string
  end
end
