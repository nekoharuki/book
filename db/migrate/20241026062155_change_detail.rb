class ChangeDetail < ActiveRecord::Migration[7.0]
  def change
    remove_column :details, :sell_item_id, :string
    remove_column :details, :sell_user_id, :string
    remove_column :details, :buy_item_id, :string
    remove_column :details, :buy_user_id, :string

    add_column :details, :item_offered_id, :integer
    add_column :details, :item_requested_id, :integer
    add_column :details, :user_offered_id, :integer
    add_column :details, :user_requested_id, :integer

  end
end
