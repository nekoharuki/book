class AddItemsPoint < ActiveRecord::Migration[7.0]
  def change
    add_column :items,:help_point,:integer
    add_column :items,:recommend_point,:integer
    add_column :items,:learn_point,:integer
  end
end
