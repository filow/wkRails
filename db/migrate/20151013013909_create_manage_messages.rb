class CreateManageMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title,null: false
      t.text :content
      t.boolean :is_readed,default: false
      t.string :from
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
