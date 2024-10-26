class DropTradesTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :trades
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
