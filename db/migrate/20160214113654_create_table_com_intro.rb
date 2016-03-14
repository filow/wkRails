class CreateTableComIntro < ActiveRecord::Migration
  def change
    create_table :com_intros do |t|
      t.string :name
      t.integer :post_id
      t.integer :sort, default: 1
      t.string :anchor, null: false
    end
  end
end
