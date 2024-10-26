class ChangeDetail < ActiveRecord::Migration[7.0]
  def change
    remove_column :detail, :sell_item_id, :string
    remove_column :detail, :sell_user_id, :string
    remove_column :detail, :buy_item_id, :string
    remove_column :detail, :buy_user_id, :string

    add_column :detail, :item_offered_id, :integer
    add_column :detail, :item_requested_id, :integer
    add_column :detail, :user_offered_id, :integer
    add_column :detail, :user_requested_id, :integer

  end
end
