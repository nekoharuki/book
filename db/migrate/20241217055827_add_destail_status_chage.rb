class AddDestailStatusChage < ActiveRecord::Migration[7.0]
  def change
    add_column :details,:user_offered_status,:integer
    add_column :details,:user_requested_status,:integer
  end
end
