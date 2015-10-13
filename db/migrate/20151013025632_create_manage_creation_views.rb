class CreateManageCreationViews < ActiveRecord::Migration
  def change
    create_table :creation_views do |t|
      t.belongs_to :creation
      t.string :ip, limit:39
      t.string :referer
      t.string :ua

      t.datetime :created_at
    end
  end
end
