# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_30_113537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "charts", force: :cascade do |t|
    t.integer "level", null: false
    t.integer "difficulty", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "music_id", null: false
    t.integer "ran_level"
    t.integer "s_ran_level"
    t.index ["music_id"], name: "index_charts_on_music_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "message"
    t.integer "category"
    t.boolean "no_reply"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "information", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "materials", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "style", null: false
    t.integer "version", null: false
    t.integer "pixels", array: true
  end

  create_table "musics", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "genre"
    t.integer "pixels", array: true
  end

  create_table "results", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chart_id"
    t.integer "random_option", null: false
    t.integer "medal"
    t.integer "score", null: false
    t.integer "good"
    t.integer "bad"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "gauge_amount"
    t.integer "gauge_option"
    t.datetime "played_at"
    t.index ["chart_id"], name: "index_results_on_chart_id"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "charts", "musics"
  add_foreign_key "results", "charts"
  add_foreign_key "results", "users"
end
