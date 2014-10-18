class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.timestamps
      t.string :from
      t.string :to
      t.text :message
    end
  end
end
