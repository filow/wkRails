class AddDocPptToCreation < ActiveRecord::Migration
  def change
    add_column :creations, :doc, :string
    add_column :creations, :ppt, :string
  end
end
