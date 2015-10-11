class CreateManageCreations < ActiveRecord::Migration
  def change
    create_table :creations do |t|
      t.string :name
      t.text :desc
      t.string :summary
      t.string :thumb
      t.integer :status, default: 0
      t.integer :version, default: 0

      t.integer :vote_count, default: 0
      t.integer :comment_count, default: 0
      t.integer :view_count, default: 0
      t.integer :popularity, default: 0
      t.timestamps null: false
    end
  end
end
