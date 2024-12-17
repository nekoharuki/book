class AddDetailChageStatus < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:details, :user_offered_status)
      add_column :details, :user_offered_status, :integer
    end
    unless column_exists?(:details, :user_requested_status)
      add_column :details, :user_requested_status, :integer
    end
  end
end
