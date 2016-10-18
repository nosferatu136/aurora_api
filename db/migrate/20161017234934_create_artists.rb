class CreateArtists < ActiveRecord::Migration
  def up
    create_table :artists do |t|
      t.string :name
      t.text   :bio
      t.string :alias

      t.timestamps
    end
  end

  def down
    drop_table :artists
  end
end
