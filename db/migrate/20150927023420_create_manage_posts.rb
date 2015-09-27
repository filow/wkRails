class CreateManagePosts < ActiveRecord::Migration
  def change
    create_table :posts,options:"charset=utf8" do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.text :content_notag
      t.datetime :valid_from
      t.boolean :is_top, default: false
      t.boolean :is_hide, default: false

      t.timestamps null: false
    end
  end
end
