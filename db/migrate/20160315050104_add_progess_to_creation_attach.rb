class AddProgessToCreationAttach < ActiveRecord::Migration
  def change
    add_column :creation_attaches, :progress, :integer, default: 0
  end
end
