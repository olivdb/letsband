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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121116205728) do

  create_table "bands", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.integer  "genre_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "image_name"
  end

  create_table "cities", :force => true do |t|
    t.integer  "country_id"
    t.integer  "region_id"
    t.string   "name"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["name", "region_id", "country_id"], :name => "by_name_and_region_id_and_country_id", :unique => true
  add_index "cities", ["name"], :name => "index_cities_on_name"

  create_table "contact_records", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contact_records", ["owner_id", "contact_id"], :name => "index_contact_records_on_owner_id_and_contact_id", :unique => true
  add_index "contact_records", ["owner_id"], :name => "index_contact_records_on_owner_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "countries", ["code"], :name => "index_countries_on_code", :unique => true
  add_index "countries", ["name"], :name => "index_countries_on_name", :unique => true

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "instruments", :force => true do |t|
    t.string   "name"
    t.string   "image_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "band_id"
    t.integer  "instrument_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "role"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "inviting_band_id"
  end

  create_table "regions", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "regions", ["code", "country_id"], :name => "by_code_and_country_id", :unique => true

  create_table "skills", :force => true do |t|
    t.integer  "user_id"
    t.integer  "instrument_id"
    t.integer  "priority"
    t.integer  "expertise"
    t.integer  "experience"
    t.integer  "education"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "skills", ["instrument_id"], :name => "index_skills_on_instrument_id"
  add_index "skills", ["user_id", "instrument_id"], :name => "index_skills_on_user_id_and_instrument_id", :unique => true
  add_index "skills", ["user_id"], :name => "index_skills_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "surname"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "city_id"
  end

  add_index "users", ["city_id"], :name => "index_users_on_city_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
