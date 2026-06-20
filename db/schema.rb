# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_20_090000) do
  create_table "habit_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "habit_id", null: false
    t.date "occurred_on", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 12, scale: 2
    t.index ["habit_id", "occurred_on"], name: "index_habit_entries_on_habit_id_and_occurred_on", unique: true
    t.index ["habit_id"], name: "index_habit_entries_on_habit_id"
  end

  create_table "habits", force: :cascade do |t|
    t.string "color", default: "#10b981", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.string "tracking_type", default: "checkbox", null: false
    t.string "unit"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "position"], name: "index_habits_on_user_id_and_position"
    t.index ["user_id"], name: "index_habits_on_user_id"
    t.check_constraint "tracking_type IN ('checkbox', 'number')", name: "habits_tracking_type"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "embed_token"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["embed_token"], name: "index_users_on_embed_token", unique: true
  end

  add_foreign_key "habit_entries", "habits"
  add_foreign_key "habits", "users"
  add_foreign_key "sessions", "users"
end
