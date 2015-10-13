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

ActiveRecord::Schema.define(version: 20151013030056) do

  create_table "admins", force: :cascade do |t|
    t.string   "name",            limit: 255,                 null: false
    t.string   "password_digest", limit: 80,                  null: false
    t.string   "realname",        limit: 255,                 null: false
    t.boolean  "is_forbidden",                default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

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

  create_table "creation_authors", force: :cascade do |t|
    t.string  "name",        limit: 255
    t.boolean "sex"
    t.string  "department",  limit: 255
    t.string  "phone",       limit: 20
    t.string  "email",       limit: 255
    t.integer "creation_id", limit: 4
  end

  create_table "creation_comments", force: :cascade do |t|
    t.string   "message",     limit: 255
    t.boolean  "is_hide",                 default: false
    t.string   "ip",          limit: 39
    t.integer  "creation_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
  end

  create_table "creation_views", force: :cascade do |t|
    t.integer  "creation_id", limit: 4
    t.string   "ip",          limit: 39
    t.string   "referer",     limit: 255
    t.string   "ua",          limit: 255
    t.datetime "created_at"
  end

  create_table "creation_votes", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "creation_id", limit: 4
    t.string   "ip",          limit: 39
    t.datetime "created_at"
  end

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
    t.integer  "popularity",    limit: 4,     default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "user_id",       limit: 4,                 null: false
  end

  create_table "judges", force: :cascade do |t|
    t.integer  "rank",        limit: 4
    t.text     "comment",     limit: 65535
    t.integer  "creation_id", limit: 4
    t.integer  "admin_id",    limit: 4
    t.datetime "created_at"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "title",      limit: 255,                   null: false
    t.text     "content",    limit: 65535
    t.boolean  "is_readed",                default: false
    t.string   "from",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.string   "controller", limit: 255
    t.string   "action",     limit: 255
    t.string   "title",      limit: 255
    t.string   "remark",     limit: 255
    t.boolean  "edit_flag",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

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

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255,                 null: false
    t.string   "realname",          limit: 255,                 null: false
    t.string   "password_digest",   limit: 80,                  null: false
    t.boolean  "sex"
    t.string   "idcard",            limit: 18
    t.integer  "group",             limit: 4
    t.string   "department",        limit: 255
    t.string   "phone",             limit: 18
    t.string   "email",             limit: 255
    t.boolean  "is_forbidden",                  default: false
    t.boolean  "is_email_verified",             default: false
    t.integer  "opus_count",        limit: 4,   default: 0
    t.integer  "msg_unread",        limit: 4,   default: 0
    t.string   "avatar",            limit: 255
    t.integer  "popularity",        limit: 4,   default: 0
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

end
