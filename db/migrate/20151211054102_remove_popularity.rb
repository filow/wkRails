class RemovePopularity < ActiveRecord::Migration
  def change
    remove_column :creations, :popularity, :integer, default: 0
    remove_column :users, :popularity, :integer, default: 0
  end
end
