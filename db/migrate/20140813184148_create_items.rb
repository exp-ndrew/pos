class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.column :name, :varchar
      t.column :price, :decimal
    end
  end
end
