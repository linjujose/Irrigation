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

ActiveRecord::Schema.define(version: 20150125213624) do

  create_table "daily_daisies", force: :cascade do |t|
    t.string   "Stn_name",     limit: 255
    t.date     "Date"
    t.integer  "JulianYear",   limit: 4
    t.float    "MaxAirTem",    limit: 24
    t.float    "MinAirTemp",   limit: 24
    t.integer  "MaxRelHum",    limit: 4
    t.integer  "MinRelHum",    limit: 4
    t.float    "Precip",       limit: 24
    t.float    "Eto",          limit: 24
    t.float    "MaxWindSpeed", limit: 24
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "past_irrigations", force: :cascade do |t|
    t.string   "Crop",       limit: 255
    t.date     "Date"
    t.integer  "Value",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
