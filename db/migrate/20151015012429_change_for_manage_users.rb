class ChangeForManageUsers < ActiveRecord::Migration
  def change
    change_column :users,:sex,:integer
  end
end
