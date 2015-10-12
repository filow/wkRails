class AddUserIdToCreation < ActiveRecord::Migration
  def change
    add_column :creations, :user_id, :integer, null: false
  end
end
