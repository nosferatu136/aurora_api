class CreateAlbums < ActiveRecord::Migration
  def up
     create_table :albums do |t|
      t.string  :name
      t.integer :art_id
      t.integer :artist_id
      t.date    :released_at

      t.timestamps
    end
  end

  def down
    drop_table :albums
  end
end
