class ChangeItemsName < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :title, :string
    remove_column :items, :name, :string
  end
end
