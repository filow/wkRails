class RemoveMsgCountFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :msg_unread, :integer, default: 0
  end
end
