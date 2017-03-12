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

ActiveRecord::Schema.define(version: 8) do

  create_table "accountings", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "surname"
    t.integer  "division"
    t.integer  "department"
    t.integer  "phone"
    t.float    "voice"
    t.float    "data"
    t.float    "roaming"
    t.date     "from"
    t.date     "to"
    t.text     "note"
    t.boolean  "disabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billings", force: :cascade do |t|
    t.string   "user"
    t.string   "name"
    t.string   "department"
    t.integer  "phonenumber"
    t.date     "month"
    t.float    "limit"
    t.float    "total"
    t.float    "others"
    t.float    "overlimit"
    t.float    "pay"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "confirmations", force: :cascade do |t|
    t.string   "user"
    t.string   "mail"
    t.date     "sent"
    t.date     "ack"
    t.date     "dec"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "information"
    t.text     "reference"
  end

  create_table "sims", force: :cascade do |t|
    t.string   "serial"
    t.integer  "phone"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tariffs", force: :cascade do |t|
    t.string   "user"
    t.string   "username"
    t.string   "department"
    t.string   "division"
    t.integer  "phone"
    t.string   "tariffVoice"
    t.string   "tariffData"
    t.string   "note"
    t.boolean  "valid"
    t.date     "validFrom"
    t.date     "validTo"
    t.date     "change"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
