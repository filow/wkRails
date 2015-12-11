class RemoveIdcardFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :idcard, :string, length: 18
  end
end
