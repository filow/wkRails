class CreateManageCreationAttaches < ActiveRecord::Migration
  def change
    create_table :creation_attaches do |t|
      t.string :filename
      t.string :original_filename
      t.string :mime
      t.integer :creation_id
      t.boolean :is_tran
      t.integer :stat, default: 0

      t.timestamps null: false
    end
  end
end
