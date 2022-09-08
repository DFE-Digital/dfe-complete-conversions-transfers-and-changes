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

ActiveRecord::Schema[7.0].define(version: 2022_09_06_151837) do
  create_table "actions", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "order", null: false
    t.boolean "completed", default: false, null: false
    t.uuid "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "hint"
    t.string "guidance_summary"
    t.text "guidance_text"
    t.index ["task_id"], name: "index_actions_on_task_id"
  end

  create_table "contacts", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.string "name", null: false
    t.string "title", null: false
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0, null: false
    t.index ["category"], name: "index_contacts_on_category"
    t.index ["project_id"], name: "index_contacts_on_project_id"
  end

  create_table "notes", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.text "body"
    t.uuid "project_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_notes_on_project_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "projects", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.integer "urn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "team_leader_id"
    t.integer "trust_ukprn", null: false
    t.date "target_completion_date", null: false
    t.uuid "regional_delivery_officer_id"
    t.uuid "caseworker_id"
    t.datetime "caseworker_assigned_at"
    t.index ["caseworker_id"], name: "index_projects_on_caseworker_id"
    t.index ["regional_delivery_officer_id"], name: "index_projects_on_regional_delivery_officer_id"
    t.index ["team_leader_id"], name: "index_projects_on_team_leader_id"
    t.index ["urn"], name: "index_projects_on_urn"
  end

  create_table "sections", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "order", null: false
    t.uuid "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_sections_on_project_id"
  end

  create_table "tasks", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.integer "order", null: false
    t.boolean "completed", default: false, null: false
    t.uuid "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "hint"
    t.string "guidance_summary"
    t.text "guidance_text"
    t.boolean "optional"
    t.boolean "not_applicable", default: false
    t.index ["section_id"], name: "index_tasks_on_section_id"
  end

  create_table "users", id: :uuid, default: -> { "newid()" }, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "team_leader", default: false
    t.boolean "regional_delivery_officer", default: false, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "active_directory_user_id"
    t.boolean "caseworker", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "actions", "tasks"
  add_foreign_key "contacts", "projects"
  add_foreign_key "notes", "projects"
  add_foreign_key "notes", "users"
  add_foreign_key "projects", "users", column: "caseworker_id"
  add_foreign_key "projects", "users", column: "regional_delivery_officer_id"
  add_foreign_key "projects", "users", column: "team_leader_id"
  add_foreign_key "sections", "projects"
  add_foreign_key "tasks", "sections"
end
