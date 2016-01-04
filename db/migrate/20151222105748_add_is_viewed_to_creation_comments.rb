class AddIsViewedToCreationComments < ActiveRecord::Migration
  def change
    add_column :creation_comments, :is_viewed, :boolean, default: false
    rename_column :creation_comments, :is_hide, :is_hidden
  end
end
