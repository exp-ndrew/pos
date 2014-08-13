class ChangeItems < ActiveRecord::Migration
  def change
    change_table :items do |t|
      t.column :quantity, :int
    end
  end
end
