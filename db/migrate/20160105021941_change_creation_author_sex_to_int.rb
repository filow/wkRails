class ChangeCreationAuthorSexToInt < ActiveRecord::Migration
  def change
    remove_column :creation_authors, :sex, :boolean
    add_column :creation_authors, :sex, :integer
  end
end
