class CreateManageCreationAuthors < ActiveRecord::Migration
  def change
    create_table :creation_authors do |t|
      t.string :name
      t.boolean :sex, null: true
      t.string :department
      t.string :phone, limit: 20
      t.string :email
      t.belongs_to :creation
    end
  end
end
