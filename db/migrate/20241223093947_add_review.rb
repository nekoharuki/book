class AddReview < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :point
      t.text :comment

      t.timestamps
    end
  end
end
