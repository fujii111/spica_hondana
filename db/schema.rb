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

ActiveRecord::Schema.define(version: 20160428040504) do

  create_table "belongs", force: true do |t|
    t.integer  "genre_id"
    t.integer  "book_id"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "belongs", ["book_id"], name: "index_belongs_on_book_id", using: :btree
  add_index "belongs", ["genre_id"], name: "index_belongs_on_genre_id", using: :btree

  create_table "books", force: true do |t|
    t.integer  "member_id"
    t.string   "title"
    t.string   "publisher"
    t.string   "author"
    t.string   "language"
    t.string   "sale_date"
    t.float    "height"
    t.float    "width"
    t.float    "depth"
    t.string   "isbn"
    t.text     "description"
    t.binary   "image",       limit: 16777215
    t.boolean  "delete_flg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["member_id"], name: "index_books_on_member_id", using: :btree

  create_table "collections", force: true do |t|
    t.integer  "member_id"
    t.integer  "request_member_id"
    t.integer  "book_id"
    t.float    "height"
    t.float    "width"
    t.float    "depth"
    t.float    "weight"
    t.integer  "condition"
    t.boolean  "sunburn"
    t.boolean  "scratch"
    t.integer  "line"
    t.integer  "broken"
    t.boolean  "band"
    t.boolean  "cigar"
    t.boolean  "pet"
    t.boolean  "mold"
    t.binary   "image"
    t.text     "note"
    t.integer  "state"
    t.datetime "regist_date"
    t.datetime "request_date"
    t.datetime "accept_date"
    t.datetime "send_date"
    t.datetime "receive_date"
    t.binary   "label",             limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evaluations", force: true do |t|
    t.integer  "collection_id"
    t.integer  "rate"
    t.integer  "state"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: true do |t|
    t.integer  "book_id"
    t.integer  "member_id"
    t.datetime "create_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["book_id"], name: "index_favorites_on_book_id", using: :btree
  add_index "favorites", ["member_id"], name: "index_favorites_on_member_id", using: :btree

  create_table "genres", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sort"
    t.boolean  "delete_flg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests", force: true do |t|
    t.integer  "member_id"
    t.integer  "genre_id"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interests", ["genre_id"], name: "index_interests_on_genre_id", using: :btree
  add_index "interests", ["member_id"], name: "index_interests_on_member_id", using: :btree

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

  create_table "messages", force: true do |t|
    t.integer  "member_id"
    t.datetime "notice_date"
    t.string   "title"
    t.text     "content"
    t.boolean  "read_flg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["member_id"], name: "index_messages_on_member_id", using: :btree

  create_table "notices", force: true do |t|
    t.text     "content"
    t.datetime "notice_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", force: true do |t|
    t.string   "inquiry_mail"
    t.string   "clickpost_url"
    t.integer  "request_limit"
    t.integer  "default_point"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
