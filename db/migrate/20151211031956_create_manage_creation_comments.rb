class CreateManageCreationComments < ActiveRecord::Migration
  def change
    create_table :creation_comments do |t|
      t.text :message
      t.boolean :is_hide, default: false
      t.string :ip
      t.belongs_to :creation
      t.belongs_to :user
      t.datetime :created_at
    end
  end
end
