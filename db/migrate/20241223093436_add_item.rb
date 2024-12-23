class AddItem < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :title
      t.string :author
      t.string :publisher
      t.string :content
      t.string :category
      t.integer :user_id
      t.string :image
      t.integer :help_point
      t.integer :recommend_point
      t.integer :learn_point
      t.string :condition
      t.integer :status

      t.timestamps
    end
  end
end
