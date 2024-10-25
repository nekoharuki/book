class CreateDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :details do |t|
      t.string :sell_user_id
      t.string :sell_item_id
      t.string :buy_user_id
      t.string :buy_item_id

      t.timestamps
    end
  end
end
