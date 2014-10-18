class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :telephone, null: false
      t.text :objective
      t.text :key
      t.integer :result
    end
  end
end
