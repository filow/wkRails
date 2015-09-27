class CreateManageUsers < ActiveRecord::Migration
  def change
    create_table :users,options:"charset=utf8" do |t|
      t.string :name, null: false
      t.string :realname, null: false
      t.string :password_digest, limit: 80, null: false
      t.boolean :sex, null: true
      t.string :idcard, null: true, limit: 18
      t.integer :group, null: true
      t.string :department
      t.string :phone,limit: 18
      t.string :email
      t.boolean :is_forbidden, default: false
      t.boolean :is_email_verified, default: false
      t.integer :opus_count, default: 0
      t.integer :msg_unread, default: 0
      t.string :avatar
      t.integer :popularity,default: 0

      t.timestamps null: false
    end
  end
end
