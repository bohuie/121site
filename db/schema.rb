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

ActiveRecord::Schema.define(version: 20170525184532) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "title"
    t.string   "subject"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "instructor_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "game_id",   default: 0, null: false
    t.integer "user_id",   default: 0, null: false
    t.integer "topic_id",  default: 0, null: false
    t.integer "number",    default: 0, null: false
    t.integer "correct",   default: 0, null: false
    t.string  "name"
    t.integer "course_id"
  end

  create_table "practices", force: :cascade do |t|
    t.integer  "game_id",     default: 0,     null: false
    t.integer  "practice_id", default: 0,     null: false
    t.integer  "user_id",     default: 0,     null: false
    t.integer  "question_id", default: 0,     null: false
    t.integer  "topic_id",    default: 0,     null: false
    t.integer  "attempts",    default: 0,     null: false
    t.integer  "answer"
    t.boolean  "correct",     default: false, null: false
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "totaltime"
    t.integer  "course_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text     "qtext"
    t.text     "a1text"
    t.text     "a2text"
    t.text     "a3text"
    t.text     "a4text"
    t.text     "a5text"
    t.integer  "answer"
    t.integer  "user_id",        default: 0,     null: false
    t.integer  "question_id",    default: 0,     null: false
    t.integer  "topic_id",       default: 0,     null: false
    t.boolean  "submitted",      default: false, null: false
    t.text     "grade",          default: "",    null: false
    t.boolean  "visible",        default: true,  null: false
    t.boolean  "exam",           default: false, null: false
    t.string   "lab"
    t.datetime "date_submitted"
    t.string   "fname"
    t.string   "lname"
    t.integer  "studentnumber"
    t.integer  "course_id"
  end

  create_table "results", force: :cascade do |t|
    t.string "name"
    t.string "lab"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "student_courses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string  "name"
    t.integer "topic_id",  default: 0, null: false
    t.integer "course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.integer  "user_id",                default: 0,     null: false
    t.string   "email",                  default: "",    null: false
    t.boolean  "assistant",              default: false
    t.boolean  "instructor",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "fname"
    t.string   "lname"
    t.string   "lab"
    t.integer  "studentnumber"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
