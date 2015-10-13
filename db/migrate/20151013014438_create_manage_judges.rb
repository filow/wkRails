class CreateManageJudges < ActiveRecord::Migration
  def change
    create_table :judges do |t|
      t.integer :rank
      t.text :comment
      t.belongs_to :creation
      t.belongs_to :admin
      t.datetime :created_at
    end
  end
end
