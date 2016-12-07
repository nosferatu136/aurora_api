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

ActiveRecord::Schema.define(:version => 20161207010901) do

  create_table "album_songs", :force => true do |t|
    t.integer  "album_id"
    t.integer  "song_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.integer  "art_id"
    t.integer  "artist_id"
    t.date     "released_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "guid"
  end

  add_index "albums", ["guid"], :name => "index_albums_on_guid"

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "alias"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "guid"
  end

  add_index "artists", ["guid"], :name => "index_artists_on_guid"

  create_table "playlist_songs", :force => true do |t|
    t.integer  "playlist_id"
    t.integer  "song_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "playlists", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "guid"
  end

  add_index "playlists", ["guid"], :name => "index_playlists_on_guid"

  create_table "songs", :force => true do |t|
    t.string   "name"
    t.integer  "duration"
    t.integer  "artist_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "guid"
  end

  add_index "songs", ["guid"], :name => "index_songs_on_guid"

end
