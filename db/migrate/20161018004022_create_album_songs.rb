class CreateAlbumSongs < ActiveRecord::Migration
  def up
    create_table :album_songs do |t|
      t.integer :album_id
      t.integer :song_id

      t.timestamps
    end
  end

  def down
    drop_table :album_songs
  end
end
