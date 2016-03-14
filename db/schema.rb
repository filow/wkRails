# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160214113654) do

  create_table "admins", force: :cascade do |t|
    t.string   "name",            limit: 255,                 null: false
    t.string   "password_digest", limit: 80,                  null: false
    t.string   "realname",        limit: 255,                 null: false
    t.boolean  "is_forbidden",                default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "is_super",                    default: false
  end

  create_table "admins_roles", id: false, force: :cascade do |t|
    t.integer "admin_id", limit: 4, null: false
    t.integer "role_id",  limit: 4, null: false
  end

  add_index "admins_roles", ["admin_id", "role_id"], name: "index_admins_roles_on_admin_id_and_role_id", using: :btree
  add_index "admins_roles", ["role_id"], name: "fk_rails_e8d2351252", using: :btree

  create_table "cfgs", force: :cascade do |t|
    t.string "key",        limit: 255
    t.string "remark",     limit: 255
    t.string "field_type", limit: 255
    t.string "value",      limit: 255
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "com_intros", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "post_id", limit: 4
    t.integer "sort",    limit: 4,   default: 1
    t.string  "anchor",  limit: 255,             null: false
  end

  create_table "creation_authors", force: :cascade do |t|
    t.string  "name",        limit: 255
    t.string  "department",  limit: 255
    t.string  "phone",       limit: 20
    t.string  "email",       limit: 255
    t.integer "creation_id", limit: 4
    t.integer "sex",         limit: 4
  end

  add_index "creation_authors", ["creation_id"], name: "fk_rails_45742f63c8", using: :btree

  create_table "creation_comments", force: :cascade do |t|
    t.text     "message",     limit: 65535
    t.boolean  "is_hidden",                 default: false
    t.string   "ip",          limit: 255
    t.integer  "creation_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.boolean  "is_viewed",                 default: false
  end

  add_index "creation_comments", ["creation_id"], name: "fk_rails_1a9d4df8bc", using: :btree
  add_index "creation_comments", ["user_id"], name: "fk_rails_520ce5b250", using: :btree

  create_table "creation_views", force: :cascade do |t|
    t.integer  "creation_id", limit: 4
    t.string   "ip",          limit: 39
    t.string   "referer",     limit: 255
    t.string   "ua",          limit: 255
    t.datetime "created_at"
  end

  add_index "creation_views", ["creation_id"], name: "fk_rails_4b86182685", using: :btree

  create_table "creation_votes", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "creation_id", limit: 4
    t.string   "ip",          limit: 39
    t.datetime "created_at"
  end

  add_index "creation_votes", ["creation_id"], name: "fk_rails_ea0f739a87", using: :btree
  add_index "creation_votes", ["user_id"], name: "fk_rails_de66e966ce", using: :btree

  create_table "creations", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "desc",          limit: 65535
    t.string   "summary",       limit: 255
    t.string   "thumb",         limit: 255
    t.integer  "status",        limit: 4,     default: 0
    t.integer  "version",       limit: 4,     default: 0
    t.integer  "vote_count",    limit: 4,     default: 0
    t.integer  "comment_count", limit: 4,     default: 0
    t.integer  "view_count",    limit: 4,     default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "user_id",       limit: 4,                 null: false
    t.string   "doc",           limit: 255
    t.string   "ppt",           limit: 255
  end

  add_index "creations", ["user_id"], name: "fk_rails_a152910aea", using: :btree

  create_table "expvideos", force: :cascade do |t|
    t.string  "name",   limit: 255
    t.string  "author", limit: 255
    t.string  "video",  limit: 255
    t.boolean "thumb",              default: false
  end

  create_table "judges", force: :cascade do |t|
    t.integer  "rank",        limit: 4
    t.text     "comment",     limit: 65535
    t.integer  "creation_id", limit: 4
    t.integer  "admin_id",    limit: 4
    t.datetime "created_at"
  end

  add_index "judges", ["admin_id"], name: "fk_rails_9de3f96c22", using: :btree
  add_index "judges", ["creation_id"], name: "fk_rails_40ed632993", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "title",      limit: 255,                   null: false
    t.text     "content",    limit: 65535
    t.boolean  "is_readed",                default: false
    t.string   "from",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "messages", ["user_id"], name: "fk_rails_273a25a7a6", using: :btree

  create_table "nodes", force: :cascade do |t|
    t.string "controller", limit: 255
    t.string "action",     limit: 255
    t.string "title",      limit: 255
    t.string "remark",     limit: 255
  end

  create_table "nodes_roles", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4, null: false
    t.integer "node_id", limit: 4, null: false
  end

  add_index "nodes_roles", ["node_id"], name: "fk_rails_c047f5d103", using: :btree
  add_index "nodes_roles", ["role_id", "node_id"], name: "index_nodes_roles_on_role_id_and_node_id", using: :btree

  create_table "option_records", force: :cascade do |t|
    t.integer  "admin_id",   limit: 4,     null: false
    t.string   "target",     limit: 255,   null: false
    t.string   "params",     limit: 255,   null: false
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
  end

  add_index "option_records", ["admin_id"], name: "fk_rails_bf57c3ab3b", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",         limit: 255,                   null: false
    t.text     "content",       limit: 65535,                 null: false
    t.text     "content_notag", limit: 65535
    t.boolean  "is_top",                      default: false
    t.boolean  "is_hide",                     default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.date     "publish_at"
  end

  create_table "roles", force: :cascade do |t|
    t.boolean "is_enabled",             default: true
    t.string  "name",       limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255,                 null: false
    t.string   "realname",          limit: 255,                 null: false
    t.string   "password_digest",   limit: 80,                  null: false
    t.integer  "sex",               limit: 4
    t.integer  "group",             limit: 4
    t.string   "department",        limit: 255
    t.string   "phone",             limit: 18
    t.string   "email",             limit: 255
    t.boolean  "is_forbidden",                  default: false
    t.boolean  "is_email_verified",             default: false
    t.string   "avatar",            limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "activation_digest", limit: 255
  end

  add_foreign_key "admins_roles", "admins", on_delete: :cascade
  add_foreign_key "admins_roles", "roles", on_delete: :cascade
  add_foreign_key "creation_authors", "creations", on_delete: :cascade
  add_foreign_key "creation_comments", "creations", on_delete: :cascade
  add_foreign_key "creation_comments", "users", on_delete: :cascade
  add_foreign_key "creation_views", "creations", on_delete: :cascade
  add_foreign_key "creation_votes", "creations", on_delete: :cascade
  add_foreign_key "creation_votes", "users", on_delete: :cascade
  add_foreign_key "creations", "users"
  add_foreign_key "judges", "admins", on_delete: :cascade
  add_foreign_key "judges", "creations", on_delete: :cascade
  add_foreign_key "messages", "users", on_delete: :cascade
  add_foreign_key "nodes_roles", "nodes", on_delete: :cascade
  add_foreign_key "nodes_roles", "roles", on_delete: :cascade
  add_foreign_key "option_records", "admins"
end
