class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :author
      t.string :publisher
      t.string :content
      t.string :situation
      t.string :category
      t.integer :user_id
      t.string :image

      t.timestamps
    end
  end
end
