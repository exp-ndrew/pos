class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.column :clerk_id, :int

      t.timestamps
    end
  end
end
