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

ActiveRecord::Schema.define(version: 20160312160948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locker_room_mateships", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.integer  "role",       limit: 2, default: 1
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["team_id"], name: "index_locker_room_mateships_on_team_id", using: :btree
    t.index ["user_id"], name: "index_locker_room_mateships_on_user_id", using: :btree
  end

  create_table "locker_room_teams", force: :cascade do |t|
    t.string   "name"
    t.string   "subdomain"
    t.integer  "type_id"
    t.string   "subscription_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["subdomain"], name: "index_locker_room_teams_on_subdomain", using: :btree
    t.index ["subscription_id"], name: "index_locker_room_teams_on_subscription_id", using: :btree
    t.index ["type_id"], name: "index_locker_room_teams_on_type_id", using: :btree
  end

  create_table "locker_room_types", force: :cascade do |t|
    t.string   "plan_id"
    t.string   "name"
    t.float    "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_locker_room_types_on_plan_id", using: :btree
  end

  create_table "locker_room_users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email",                           null: false
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.index ["email"], name: "index_locker_room_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_locker_room_users_on_reset_password_token", using: :btree
    t.index ["username"], name: "index_locker_room_users_on_username", unique: true, using: :btree
  end

  create_table "talks", force: :cascade do |t|
    t.string   "theme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
