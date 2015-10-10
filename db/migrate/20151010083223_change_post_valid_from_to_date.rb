class ChangePostValidFromToDate < ActiveRecord::Migration
  def change
    remove_column :posts, :valid_from, :datetime
    add_column :posts, :publish_at, :date
  end
end
