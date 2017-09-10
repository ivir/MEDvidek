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

ActiveRecord::Schema.define(version: 11) do

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

  create_table "contacts", force: :cascade do |t|
    t.integer "persona_id"
    t.text    "type"
    t.text    "value"
    t.index ["persona_id"], name: "index_contacts_on_persona_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "sim_id"
    t.float    "total"
    t.float    "others"
    t.float    "request"
    t.date     "month"
    t.boolean  "correction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sim_id"], name: "index_invoices_on_sim_id"
  end

  create_table "limits", force: :cascade do |t|
    t.text     "name"
    t.text     "parameter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mobiles", force: :cascade do |t|
    t.integer  "persona_id"
    t.integer  "sim_id"
    t.integer  "package_id"
    t.date     "from"
    t.date     "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_mobiles_on_package_id"
    t.index ["persona_id"], name: "index_mobiles_on_persona_id"
    t.index ["sim_id"], name: "index_mobiles_on_sim_id"
  end

  create_table "packages", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "packages_tariffs", id: false, force: :cascade do |t|
    t.integer "package_id"
    t.integer "tariff_id"
    t.index ["package_id"], name: "index_packages_tariffs_on_package_id"
    t.index ["tariff_id"], name: "index_packages_tariffs_on_tariff_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "persona_id"
    t.text    "type"
    t.text    "value"
    t.index ["persona_id"], name: "index_payments_on_persona_id"
  end

  create_table "personas", force: :cascade do |t|
    t.text     "name"
    t.text     "surname"
    t.text     "username"
    t.text     "title"
    t.text     "postitle"
    t.text     "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "contact_id"
    t.integer  "payment_id"
    t.index ["contact_id"], name: "index_personas_on_contact_id"
    t.index ["payment_id"], name: "index_personas_on_payment_id"
  end

  create_table "sims", force: :cascade do |t|
    t.string   "serial"
    t.integer  "phone"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tariffs", force: :cascade do |t|
    t.integer  "limit_id"
    t.text     "name"
    t.float    "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["limit_id"], name: "index_tariffs_on_limit_id"
  end

  create_table "travels", force: :cascade do |t|
    t.integer  "phone"
    t.date     "from"
    t.date     "till"
    t.integer  "package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
