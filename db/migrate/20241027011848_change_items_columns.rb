class ChangeItemsColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :items,:condition,:string
    add_column :items,:status,:integer

    remove_column :items,:situation,:string

  end
end
