class RemoveTimestampFromNode < ActiveRecord::Migration
  def change
    remove_column :nodes, :created_at, :datetime
    remove_column :nodes, :updated_at, :datetime
    remove_column :nodes, :edit_flag, :boolean
  end
end
