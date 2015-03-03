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

ActiveRecord::Schema.define(version: 20150303035208) do

  create_table "books", force: true do |t|
    t.integer  "member_id"
    t.string   "name"
    t.string   "publisher"
    t.string   "author"
    t.string   "language"
    t.string   "sale_date"
    t.float    "height"
    t.float    "width"
    t.float    "depth"
    t.string   "isbn"
    t.text     "description"
    t.binary   "image"
    t.boolean  "delete_flg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["member_id"], name: "index_books_on_member_id"

  create_table "genres", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sort"
    t.boolean  "delete_flg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.string   "login_id"
    t.string   "password"
    t.string   "reset_token"
    t.datetime "reset_limit"
    t.string   "name"
    t.string   "kana"
    t.string   "nickname"
    t.date     "birthday"
    t.string   "mail_address"
    t.string   "address"
    t.integer  "point"
    t.string   "favorite_author1"
    t.string   "favorite_author2"
    t.string   "favorite_author3"
    t.string   "favorite_author4"
    t.string   "favorite_author5"
    t.boolean  "delete_flg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", force: true do |t|
    t.text     "content"
    t.datetime "notice_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
