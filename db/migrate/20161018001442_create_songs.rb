class CreateSongs < ActiveRecord::Migration
  def up
    create_table :songs do |t|
      t.string  :name
      t.integer :duration
      t.integer :artist_id

      t.timestamps
    end
  end

  def down
    drop_table :songs
  end
end
