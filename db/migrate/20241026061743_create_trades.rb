class CreateTrades < ActiveRecord::Migration[7.0]
  def change
    create_table :trades do |t|
      t.integer :item_offered_id
      t.integer :item_requested_id
      t.integer :user_offered_id
      t.integer :user_requested_id

      t.timestamps
    end
  end
end
