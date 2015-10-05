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

ActiveRecord::Schema.define(version: 20151005174606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locker_room_mateships", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "role",       limit: 2, default: 1
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "locker_room_mateships", ["team_id"], name: "index_locker_room_mateships_on_team_id", using: :btree
  add_index "locker_room_mateships", ["user_id"], name: "index_locker_room_mateships_on_user_id", using: :btree

  create_table "locker_room_plans", force: :cascade do |t|
    t.string   "name"
    t.float    "price"
    t.string   "braintree_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "locker_room_teams", force: :cascade do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "plan_id"
    t.string   "subscription_id"
  end

  add_index "locker_room_teams", ["subdomain"], name: "index_locker_room_teams_on_subdomain", using: :btree

  create_table "locker_room_users", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "username"
    t.string   "name"
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "locker_room_users", ["team_id", "email"], name: "index_locker_room_users_on_team_id_and_email", unique: true, using: :btree
  add_index "locker_room_users", ["team_id", "username"], name: "index_locker_room_users_on_team_id_and_username", unique: true, using: :btree

  create_table "talks", force: :cascade do |t|
    t.string   "theme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
