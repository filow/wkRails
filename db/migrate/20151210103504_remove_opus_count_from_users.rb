class RemoveOpusCountFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :opus_count, :integer, default: 0
  end
end
