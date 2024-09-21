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

ActiveRecord::Schema[7.0].define(version: 2024_09_21_210136) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_prompts", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "prompt_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_prompts_on_game_id"
    t.index ["prompt_id"], name: "index_game_prompts_on_prompt_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "room_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "winner_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "host", default: false
    t.index ["game_id"], name: "index_players_on_game_id"
  end

  create_table "prompts", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "player_id"
    t.string "text", null: false
    t.boolean "correct", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prompt_id"
    t.index ["player_id"], name: "index_responses_on_player_id"
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "response_id"
    t.index ["player_id"], name: "index_votes_on_player_id"
  end

  add_foreign_key "game_prompts", "games"
  add_foreign_key "game_prompts", "prompts"
  add_foreign_key "responses", "players"
end
