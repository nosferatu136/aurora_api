class AddGuidToModels < ActiveRecord::Migration
  def up
    add_column :albums, :guid, :string
    add_column :artists, :guid, :string
    add_column :playlists, :guid, :string
    add_column :songs, :guid, :string

    add_index :albums, :guid
    add_index :artists, :guid
    add_index :playlists, :guid
    add_index :songs, :guid
  end

  def down
    remove_index :albums, :guid
    remove_index :artists, :guid
    remove_index :playlists, :guid
    remove_index :songs, :guid

    remove_column :albums, :guid, :string
    remove_column :artists, :guid, :string
    remove_column :playlists, :guid, :string
    remove_column :songs, :guid, :string
  end
end
