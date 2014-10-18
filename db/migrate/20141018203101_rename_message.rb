class RenameMessage < ActiveRecord::Migration
  def change
    rename_column :messages, :message, :text
  end
end
