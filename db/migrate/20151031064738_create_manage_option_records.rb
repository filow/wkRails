class CreateManageOptionRecords < ActiveRecord::Migration
  def change
    create_table :option_records,options:"charset=utf8"  do |t|
      t.integer :admin_id, null:false
      t.string :target, null:false
      t.string :params, null:false
      t.text :desc
      t.datetime :created_at, null:false
    end
  end
end
