# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080919194805) do

  create_table "albums", :force => true do |t|
    t.integer  "person_id"
    t.string   "name",       :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "person_id"
    t.integer  "picture_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "following_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name", :limit => nil
    t.string   "last_name",  :limit => nil
    t.string   "password",   :limit => nil
    t.string   "salt",       :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",      :limit => nil
  end

  create_table "pictures", :force => true do |t|
    t.string   "title",          :limit => nil
    t.integer  "person_id"
    t.string   "mime_type",      :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data",           :limit => nil
    t.string   "filename",       :limit => nil
    t.integer  "album_id"
    t.string   "thumbnail_data", :limit => nil
  end

  create_table "taggings", :force => true do |t|
    t.string   "taggable_type", :limit => nil
    t.integer  "taggable_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name",       :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
