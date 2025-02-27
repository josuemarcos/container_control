class RenameCodigoToCodeInImages < ActiveRecord::Migration[7.2]
  def change
    rename_column :images, :codigo, :code
  end
end
