class CreateManageNodes < ActiveRecord::Migration
  def change
    create_table :manage_nodes do |t|
      t.string :name
      t.string :title
      t.string :remark
      t.boolean :edit_flag

      t.timestamps null: false
    end
  end
end
