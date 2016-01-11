class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :admins_roles, :admins, on_delete: :cascade
    add_foreign_key :admins_roles, :roles, on_delete: :cascade
    add_foreign_key :creation_authors, :creations, on_delete: :cascade
    add_foreign_key :creation_comments, :creations, on_delete: :cascade
    add_foreign_key :creation_comments, :users, on_delete: :cascade
    add_foreign_key :creation_views, :creations, on_delete: :cascade
    add_foreign_key :creation_votes, :creations, on_delete: :cascade
    add_foreign_key :creation_votes, :users, on_delete: :cascade
    # 这里的删除让rails来
    add_foreign_key :creations, :users
    add_foreign_key :judges, :creations, on_delete: :cascade
    add_foreign_key :judges, :admins, on_delete: :cascade
    add_foreign_key :messages, :users, on_delete: :cascade
    add_foreign_key :nodes_roles, :nodes, on_delete: :cascade
    add_foreign_key :nodes_roles, :roles, on_delete: :cascade
    # 日志不删除
    add_foreign_key :option_records, :admins

  end
end
