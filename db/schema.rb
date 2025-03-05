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

ActiveRecord::Schema[8.0].define(version: 2025_03_05_172613) do
  create_table "chat_messages", force: :cascade do |t|
    t.integer "game_id", null: false
    t.string "author"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author_color"
    t.index ["game_id"], name: "index_chat_messages_on_game_id"
  end

  create_table "game_coordinates", force: :cascade do |t|
    t.float "lat"
    t.float "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id", null: false
    t.index ["game_id"], name: "index_game_coordinates_on_game_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "user_id", null: false
    t.boolean "ready", default: false
    t.integer "answers", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "current_answer"
    t.string "color"
    t.string "connection", default: "offline"
    t.index ["game_id"], name: "index_game_players_on_game_id"
    t.index ["user_id"], name: "index_game_players_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "steps", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phase", default: "lobby"
    t.string "creator"
    t.integer "current_step", default: 1
    t.string "answer"
    t.text "current_coordinates"
    t.text "current_streets"
    t.string "game_type"
    t.string "name"
    t.integer "story_id"
    t.integer "current_question_id"
    t.integer "lesson_id"
    t.text "lesson_state"
    t.index ["current_question_id"], name: "index_games_on_current_question_id"
    t.index ["lesson_id"], name: "index_games_on_lesson_id"
    t.index ["story_id"], name: "index_games_on_story_id"
  end

  create_table "games_statistics", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "game_type"
    t.integer "questions"
    t.integer "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_games_statistics_on_user_id"
  end

  create_table "lesson_answers", force: :cascade do |t|
    t.integer "lesson_question_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_question_id"], name: "index_lesson_answers_on_lesson_question_id"
  end

  create_table "lesson_questions", force: :cascade do |t|
    t.integer "lesson_id", null: false
    t.string "content"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_questions_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "random_coordinates", force: :cascade do |t|
    t.float "lat"
    t.float "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visibility", default: "visible"
  end

  create_table "story_questions", force: :cascade do |t|
    t.integer "story_id", null: false
    t.string "question"
    t.string "answer"
    t.text "options"
    t.text "coordinates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_story_questions_on_story_id"
  end

  create_table "streets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chat_messages", "games"
  add_foreign_key "game_coordinates", "games"
  add_foreign_key "game_players", "games"
  add_foreign_key "game_players", "users"
  add_foreign_key "games", "lessons", on_delete: :nullify
  add_foreign_key "games", "stories"
  add_foreign_key "games", "story_questions", column: "current_question_id"
  add_foreign_key "games_statistics", "users"
  add_foreign_key "lesson_answers", "lesson_questions"
  add_foreign_key "lesson_questions", "lessons"
  add_foreign_key "story_questions", "stories"
end
