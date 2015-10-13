class CreateJoinTableRoleNode < ActiveRecord::Migration
  def change
    create_join_table :roles, :nodes do |t|
      t.index [:role_id, :node_id]
      # t.index [:node_id, :role_id]
    end
  end
end
