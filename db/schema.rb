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

ActiveRecord::Schema.define(version: 20150818083036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "artists", force: :cascade do |t|
    t.string   "brand",      default: "", null: false
    t.string   "country"
    t.integer  "founded"
    t.integer  "closed"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "artists", ["brand"], name: "index_artists_on_brand", using: :btree

  create_table "artwork_multiple_objects", force: :cascade do |t|
    t.integer  "record_id"
    t.string   "name",       default: "", null: false
    t.string   "material"
    t.string   "system"
    t.hstore   "size"
    t.integer  "weight"
    t.integer  "duration"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "artwork_multiple_objects", ["record_id"], name: "index_artwork_multiple_objects_on_record_id", using: :btree

  create_table "base_unit_systems", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details_artworks", force: :cascade do |t|
    t.integer  "record_id"
    t.string   "manufacturer"
    t.string   "designer"
    t.string   "period"
    t.string   "packaging"
    t.hstore   "frame"
    t.string   "unique_marks"
    t.string   "additional_information"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "details_artworks", ["designer"], name: "index_details_artworks_on_designer", using: :btree
  add_index "details_artworks", ["manufacturer"], name: "index_details_artworks_on_manufacturer", using: :btree
  add_index "details_artworks", ["record_id"], name: "index_details_artworks_on_record_id", using: :btree

  create_table "editions", force: :cascade do |t|
    t.integer  "record_id"
    t.integer  "location_id"
    t.string   "primary_status"
    t.string   "secondary_status"
    t.text     "notes"
    t.string   "type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "editions", ["location_id"], name: "index_editions_on_location_id", using: :btree
  add_index "editions", ["record_id"], name: "index_editions_on_record_id", using: :btree

  create_table "exhibition_histories", force: :cascade do |t|
    t.integer  "edition_id"
    t.string   "displayed_by"
    t.string   "displayed_at"
    t.string   "title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "exhibition_histories", ["edition_id"], name: "index_exhibition_histories_on_edition_id", using: :btree

  create_table "external_artworks", force: :cascade do |t|
    t.integer  "artist_id"
    t.string   "model",      default: "", null: false
    t.integer  "year"
    t.string   "material"
    t.string   "system"
    t.hstore   "size"
    t.integer  "weight"
    t.integer  "duration"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "external_artworks", ["artist_id"], name: "index_external_artworks_on_artist_id", using: :btree
  add_index "external_artworks", ["model"], name: "index_external_artworks_on_model", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "sublocation"
    t.text     "location_notes"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "prior_ownerships", force: :cascade do |t|
    t.integer  "edition_id"
    t.string   "owner"
    t.decimal  "purchase_price"
    t.decimal  "sale_price"
    t.datetime "date_of_purchase"
    t.datetime "date_of_sale"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "prior_ownerships", ["edition_id"], name: "index_prior_ownerships_on_edition_id", using: :btree

  create_table "publications", force: :cascade do |t|
    t.integer  "edition_id"
    t.string   "source"
    t.string   "title"
    t.string   "author"
    t.datetime "date"
    t.text     "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "publications", ["edition_id"], name: "index_publications_on_edition_id", using: :btree

  create_table "records", force: :cascade do |t|
    t.integer  "artist_id"
    t.string   "model",      default: "", null: false
    t.integer  "year"
    t.string   "material"
    t.string   "system"
    t.hstore   "size"
    t.integer  "weight"
    t.integer  "duration"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "records", ["artist_id"], name: "index_records_on_artist_id", using: :btree
  add_index "records", ["model"], name: "index_records_on_model", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_editions", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "edition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags_editions", ["edition_id"], name: "index_tags_editions_on_edition_id", using: :btree
  add_index "tags_editions", ["tag_id"], name: "index_tags_editions_on_tag_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "type"
    t.string   "authentication_token"
    t.integer  "role_id"
    t.integer  "unit_system_id",         default: 1,  null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "artwork_multiple_objects", "records"
  add_foreign_key "details_artworks", "records"
  add_foreign_key "editions", "locations"
  add_foreign_key "editions", "records"
  add_foreign_key "exhibition_histories", "editions"
  add_foreign_key "external_artworks", "artists"
  add_foreign_key "locations", "users"
  add_foreign_key "prior_ownerships", "editions"
  add_foreign_key "publications", "editions"
  add_foreign_key "records", "artists"
  add_foreign_key "tags_editions", "editions"
  add_foreign_key "tags_editions", "tags"
end
