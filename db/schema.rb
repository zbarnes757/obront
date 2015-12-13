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

ActiveRecord::Schema.define(version: 20151213173656) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "pretty_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree
  add_index "categories", ["pretty_name"], name: "index_categories_on_pretty_name", using: :btree

  create_table "interests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "interests", ["category_id"], name: "index_interests_on_category_id", using: :btree
  add_index "interests", ["user_id"], name: "index_interests_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.string   "email"
    t.boolean  "looking_for_work", default: false
    t.boolean  "admin",            default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "classification",   default: 0
    t.string   "phone"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "payment_method"
    t.string   "payment_address"
    t.string   "calendly_link"
    t.text     "notes"
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["looking_for_work"], name: "index_users_on_looking_for_work", using: :btree

  add_foreign_key "interests", "categories"
  add_foreign_key "interests", "users"
end
