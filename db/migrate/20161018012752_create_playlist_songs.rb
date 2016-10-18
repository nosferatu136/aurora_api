class CreatePlaylistSongs < ActiveRecord::Migration
  def up
    create_table :playlist_songs do |t|
      t.integer :playlist_id
      t.integer :song_id

      t.timestamps
    end
  end

  def down
    drop_table :playlist_songs
  end
end
