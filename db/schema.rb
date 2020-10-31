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

ActiveRecord::Schema.define(version: 2020_10_31_175819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "username", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "group_weeks", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "week_id", null: false
    t.bigint "winner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_weeks_on_group_id"
    t.index ["week_id"], name: "index_group_weeks_on_week_id"
    t.index ["winner_id"], name: "index_group_weeks_on_winner_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "private", default: false
    t.bigint "tournament_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
    t.index ["tournament_id"], name: "index_groups_on_tournament_id"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.bigint "week_id", null: false
    t.bigint "visit_team_id", null: false
    t.bigint "home_team_id", null: false
    t.bigint "winning_team_id"
    t.boolean "untie", default: false
    t.boolean "premium", default: false
    t.integer "visit_team_score"
    t.integer "home_team_score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "show_time"
    t.integer "order"
    t.boolean "tie", default: false
    t.index ["home_team_id"], name: "index_matches_on_home_team_id"
    t.index ["visit_team_id"], name: "index_matches_on_visit_team_id"
    t.index ["week_id"], name: "index_matches_on_week_id"
    t.index ["winning_team_id"], name: "index_matches_on_winning_team_id"
  end

  create_table "membership_weeks", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.bigint "week_id", null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_membership_weeks_on_group_id"
    t.index ["membership_id"], name: "index_membership_weeks_on_membership_id"
    t.index ["week_id"], name: "index_membership_weeks_on_week_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "paid", default: false
    t.boolean "suspended", default: false
    t.string "notes"
    t.integer "position", default: 0
    t.integer "total", default: 0
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["group_id"], name: "index_memberships_on_group_id"
  end

  create_table "picks", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "picked_team_id"
    t.boolean "correct", default: false, null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "membership_week_id"
    t.index ["match_id"], name: "index_picks_on_match_id"
    t.index ["membership_week_id"], name: "index_picks_on_membership_week_id"
    t.index ["picked_team_id"], name: "index_picks_on_picked_team_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_requests_on_account_id"
    t.index ["group_id"], name: "index_requests_on_group_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_sports_on_name", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.bigint "sport_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sport_id"], name: "index_teams_on_sport_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "sport_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tournaments_on_name", unique: true
    t.index ["sport_id"], name: "index_tournaments_on_sport_id"
  end

  create_table "updates", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "phone"
    t.string "full_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_zone", default: "UTC"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "weeks", force: :cascade do |t|
    t.integer "number", null: false
    t.boolean "finished", default: false, null: false
    t.bigint "tournament_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number", "tournament_id"], name: "index_weeks_on_number_and_tournament_id", unique: true
    t.index ["tournament_id"], name: "index_weeks_on_tournament_id"
  end

  create_table "winners", force: :cascade do |t|
    t.bigint "membership_week_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_week_id"], name: "index_winners_on_membership_week_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "group_weeks", "accounts", column: "winner_id"
  add_foreign_key "group_weeks", "groups"
  add_foreign_key "group_weeks", "weeks"
  add_foreign_key "groups", "tournaments"
  add_foreign_key "matches", "teams", column: "home_team_id"
  add_foreign_key "matches", "teams", column: "visit_team_id"
  add_foreign_key "matches", "teams", column: "winning_team_id"
  add_foreign_key "matches", "weeks"
  add_foreign_key "membership_weeks", "groups"
  add_foreign_key "membership_weeks", "memberships"
  add_foreign_key "membership_weeks", "weeks"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "groups"
  add_foreign_key "picks", "matches"
  add_foreign_key "picks", "membership_weeks"
  add_foreign_key "picks", "teams", column: "picked_team_id"
  add_foreign_key "requests", "accounts"
  add_foreign_key "requests", "groups"
  add_foreign_key "teams", "sports"
  add_foreign_key "tournaments", "sports"
  add_foreign_key "weeks", "tournaments"
  add_foreign_key "winners", "membership_weeks"
end
