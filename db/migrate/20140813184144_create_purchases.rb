class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.column :item_id, :int
      t.column :quantity, :int
      t.column :transaction_id, :int
    end
  end
end
