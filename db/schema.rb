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

ActiveRecord::Schema.define(version: 20170214134031) do

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
    t.string   "social"
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
    t.text     "description"
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

  create_table "contacts", force: :cascade do |t|
    t.string   "value"
    t.integer  "customer_id"
    t.string   "notice"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "raw_value"
  end

  create_table "costume_price_positions", force: :cascade do |t|
    t.integer  "minutes"
    t.integer  "costume_count"
    t.float    "partner",       default: 0.0
    t.float    "open",          default: 0.0
    t.float    "exclusive",     default: 0.0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "customer_type"
    t.string   "name"
    t.string   "company_name"
    t.string   "contact"
    t.string   "notice"
    t.float    "discount",      default: 0.0, null: false
    t.string   "partner_link"
    t.string   "customer_name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "customers_stages", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "stage_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitation_events", force: :cascade do |t|
    t.integer  "invitation_id"
    t.integer  "author_id"
    t.integer  "event_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "author_type"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "actor_id"
    t.integer  "status",      default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "corrector",   default: 0
    t.integer  "position_id"
  end

  create_table "order_sources", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "customer_id"
    t.integer  "stage_id"
    t.integer  "status",                     default: 0
    t.string   "child_name"
    t.integer  "guests_age_from"
    t.integer  "guests_age_to"
    t.text     "child_notice"
    t.float    "partner_money"
    t.float    "additional_expense"
    t.boolean  "partner_payed"
    t.date     "performance_date"
    t.integer  "performance_duration"
    t.integer  "partner_id"
    t.string   "street"
    t.string   "house"
    t.integer  "order_source_id"
    t.string   "guests_notice"
    t.time     "performance_time"
    t.integer  "contact_id"
    t.date     "child_birthday"
    t.string   "order_calculations_notice"
    t.boolean  "exclude_additional_expense", default: false, null: false
    t.boolean  "exclude_outcome",            default: false, null: false
  end

  create_table "orders_characters", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string   "name"
    t.string   "contacts"
    t.string   "notice"
    t.integer  "stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "phone"
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

  create_table "positions", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "order_id"
    t.integer  "status",         default: 0
    t.datetime "start"
    t.datetime "stop"
    t.float    "price",          default: 0.0
    t.float    "overheads",      default: 0.0
    t.float    "animator_money", default: 0.0
    t.boolean  "payed",          default: false, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "order_notice"
    t.string   "actor_notice"
    t.string   "owner_class"
    t.integer  "owner_id"
    t.boolean  "animator_payed", default: false, null: false
  end

  create_table "price_positions", force: :cascade do |t|
    t.integer  "minutes"
    t.float    "animator_price",   default: 0.0
    t.float    "animator_salary",  default: 0.0
    t.integer  "animators_count"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "partner_price",    default: 0.0
    t.float    "open_price",       default: 0.0
    t.float    "exclusive_price",  default: 0.0
    t.float    "partner_salary",   default: 0.0
    t.float    "open_salary",      default: 0.0
    t.float    "exclusive_salary", default: 0.0
  end

  create_table "stages", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.string   "street"
    t.string   "house"
    t.integer  "district_id"
    t.string   "apartment"
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
