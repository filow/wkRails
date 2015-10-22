class DropCreationComment < ActiveRecord::Migration
  def change
    drop_table :creation_comments
  end
end
