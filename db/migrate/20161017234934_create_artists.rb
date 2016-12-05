class CreateArtists < ActiveRecord::Migration
  def up
    create_table :artists do |t|
      t.string :name
      t.text   :bio
      t.string :alias

      # +1 cool that you're using t.timestamps -- a lot of people use t.created_at and t.updated_at manually
      t.timestamps
    end
  end

  def down
    drop_table :artists
  end
end
