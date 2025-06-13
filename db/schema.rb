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

ActiveRecord::Schema[8.0].define(version: 2025_06_13_224705) do
  create_table "content_plan_items", force: :cascade do |t|
    t.integer "project_id", null: false
    t.text "title", null: false
    t.boolean "posted", default: false
    t.date "deadline"
    t.integer "platform", null: false
    t.json "tags", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deadline"], name: "index_content_plan_items_on_deadline"
    t.index ["platform"], name: "index_content_plan_items_on_platform"
    t.index ["posted"], name: "index_content_plan_items_on_posted"
    t.index ["project_id"], name: "index_content_plan_items_on_project_id"
  end

  create_table "project_design_links", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_design_links_on_project_id"
  end

  create_table "project_files", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "filename"
    t.binary "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_files_on_project_id"
  end

  create_table "project_map_links", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_map_links_on_project_id"
  end

  create_table "project_photos", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "url"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_photos_on_project_id"
  end

  create_table "project_reference_links", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_reference_links_on_project_id"
  end

  create_table "project_specialists", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_project_specialists_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_project_specialists_on_project_id"
    t.index ["user_id"], name: "index_project_specialists_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "creator_id"
    t.string "telegram_url"
    t.string "instagram_url"
    t.string "vkontakte_url"
    t.string "youtube_url"
    t.string "tiktok_url"
    t.string "yandex_zen_url"
    t.boolean "is_archived"
    t.binary "cover"
    t.string "code"
    t.date "expire_in"
    t.string "url"
    t.index ["creator_id"], name: "index_projects_on_creator_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "project_id", null: false
    t.date "start_date", null: false
    t.json "weekdays", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_schedules_on_project_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "phone_number"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "content_plan_items", "projects"
  add_foreign_key "project_design_links", "projects"
  add_foreign_key "project_files", "projects"
  add_foreign_key "project_map_links", "projects"
  add_foreign_key "project_photos", "projects"
  add_foreign_key "project_reference_links", "projects"
  add_foreign_key "project_specialists", "projects"
  add_foreign_key "project_specialists", "users"
  add_foreign_key "projects", "users", column: "creator_id"
  add_foreign_key "schedules", "projects"
end
