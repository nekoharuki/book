class ChangeContentToBeTextInItems < ActiveRecord::Migration[7.0]
  def change
    change_column :items, :content, :text
  end
end
