class CreateManageCreationVotes < ActiveRecord::Migration
  def change
    create_table :creation_votes do |t|
      t.belongs_to :user
      t.belongs_to :creation
      t.string :ip, limit: 39

      t.datetime :created_at
    end
  end
end
