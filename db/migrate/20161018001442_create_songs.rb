class CreateSongs < ActiveRecord::Migration
  def up
    create_table :songs do |t|
      t.string  :name
      t.integer :duration
      t.integer :artist_id

      # 0 check this out as well: https://github.com/ActsAsParanoid/acts_as_paranoid
      #   for doing soft deletes
      t.timestamps
    end
  end

  def down
    drop_table :songs
  end
end
