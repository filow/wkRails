class CreateManageCreationComments < ActiveRecord::Migration
  def change
    create_table :manage_creation_comments do |t|
      t.string :message
      t.boolean :is_hide, default: false
      # ipv6最大长度39
      t.string :ip, limit: 39
      t.belongs_to :creation
      t.belongs_to :user
      t.datetime :created_at
    end
  end
end
