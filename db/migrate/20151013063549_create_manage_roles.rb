class CreateManageRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.boolean :is_enabled, default: true
      t.string :name
    end
  end
end
