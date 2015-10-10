class CreateManageNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :controller
      t.string :action
      t.string :title
      t.string :remark
      t.boolean :edit_flag,default: false

      t.timestamps null: false
    end
  end
end
