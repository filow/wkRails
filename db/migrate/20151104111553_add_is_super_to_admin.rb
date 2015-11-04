class AddIsSuperToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :is_super, :boolean, default: false
  end
end
