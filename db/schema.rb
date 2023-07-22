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

ActiveRecord::Schema[7.0].define(version: 2023_07_22_092411) do
  create_table "article_surveys", force: :cascade do |t|
    t.string "name"
    t.text "uid"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_surveys_on_article_id"
  end

  create_table "article_videos", force: :cascade do |t|
    t.text "uid", null: false
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_videos_on_article_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "records", force: :cascade do |t|
    t.text "content", null: false
    t.date "recorded_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recorded_on"], name: "index_records_on_recorded_on", unique: true
  end

  create_table "user_video_views", force: :cascade do |t|
    t.integer "user_id"
    t.integer "video_id"
    t.decimal "play_time", precision: 10, scale: 3, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_video_views_on_user_id"
    t.index ["video_id"], name: "index_user_video_views_on_video_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
