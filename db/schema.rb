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

ActiveRecord::Schema.define(version: 20170617184006) do

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "my_process_id"
    t.text     "message"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "messages", ["my_process_id"], name: "index_messages_on_my_process_id"
  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "my_processes", force: :cascade do |t|
    t.integer  "process_type_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "hashtag"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "starts_at"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "my_processes", ["process_type_id"], name: "index_my_processes_on_process_type_id"
  add_index "my_processes", ["user_id"], name: "index_my_processes_on_user_id"

  create_table "process_types", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "hashtag"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "process_types", ["name"], name: "index_process_types_on_name"
  add_index "process_types", ["user_id"], name: "index_process_types_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_tasks", id: false, force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles_tasks", ["role_id"], name: "index_roles_tasks_on_role_id"
  add_index "roles_tasks", ["task_id"], name: "index_roles_tasks_on_task_id"

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id"

  create_table "tasks", force: :cascade do |t|
    t.integer  "my_process_id"
    t.integer  "responsible_user_id"
    t.string   "address"
    t.string   "name"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "assigned_start"
    t.datetime "assigned_end"
    t.datetime "actual_start"
    t.datetime "actual_end"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "tasks", ["my_process_id"], name: "index_tasks_on_my_process_id"
  add_index "tasks", ["responsible_user_id"], name: "index_tasks_on_responsible_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "",             null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,              null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "token"
    t.string   "secret"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "username"
    t.string   "role",                   default: "not-admitted"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "waitings", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "waiting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "waitings", ["task_id"], name: "index_waitings_on_task_id"
  add_index "waitings", ["waiting_id"], name: "index_waitings_on_waiting_id"

end
