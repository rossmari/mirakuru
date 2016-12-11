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

ActiveRecord::Schema.define(version: 20161210103302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.string   "name"
    t.string   "contacts"
    t.string   "telegram_key"
    t.string   "age"
    t.string   "phone"
    t.string   "avatar"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "actors_characters", force: :cascade do |t|
    t.integer  "actor_id"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "avatars", force: :cascade do |t|
    t.string   "file"
    t.string   "cover_type"
    t.string   "string"
    t.integer  "cover_id"
    t.integer  "integer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.integer  "duration"
    t.integer  "characters_group_id"
    t.integer  "age_from"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "avatar_id"
    t.integer  "age_to"
  end

  create_table "characters_groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "age_from"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "age_to"
  end

  create_table "characters_photos", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "customer_type"
    t.string   "name"
    t.string   "company_name"
    t.string   "contact"
    t.string   "notice"
    t.float    "discount"
    t.string   "partner_link"
    t.string   "customer_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "customer_id"
    t.integer  "character_id"
    t.integer  "performance_id"
    t.integer  "stage_id"
    t.string   "address"
    t.float    "price"
    t.integer  "status"
    t.string   "child"
    t.integer  "child_age"
    t.integer  "guests_count"
    t.integer  "guests_age_from"
    t.integer  "guests_age_to"
    t.text     "notice"
    t.boolean  "payed",           default: false, null: false
    t.integer  "partner_money"
    t.integer  "animator_money"
    t.integer  "overheads"
  end

  create_table "partners", force: :cascade do |t|
    t.string   "name"
    t.string   "contacts"
    t.string   "notice"
    t.integer  "stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performances", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "performances_characters", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "performance_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "cover_type"
    t.integer  "cover_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string   "address"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
