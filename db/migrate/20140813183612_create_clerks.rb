class CreateClerks < ActiveRecord::Migration
  def change
    create_table :clerks do |t|
      t.column :name, :varchar
      t.column :password, :varchar
    end
  end
end
