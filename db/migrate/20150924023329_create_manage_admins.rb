class CreateManageAdmins < ActiveRecord::Migration
  def change
    create_table :admins,options:"charset=utf8" do |t|
      t.string :name, null: false
      t.string :password_digest, null: false, limit: 80
      t.string :realname, null: false
      t.boolean :is_forbidden, default: false

      t.timestamps null: false
    end
  end
end
