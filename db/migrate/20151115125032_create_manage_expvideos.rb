class CreateManageExpvideos < ActiveRecord::Migration
  def change
    create_table :expvideos do |t|
      t.string :name
      t.string :author
      t.string :video
      t.string :thumb
    end
  end
end
