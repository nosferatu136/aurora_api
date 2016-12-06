class AlbumsController < CommonMusicController
  include HasSongLists

  before_filter :assign_music_entity, only: [:add_songs, :remove_songs, :show, :update, :destroy]

  def music_entity_name
    :album
  end

  def music_entity_attributes
    [:name, :artist_id, :art_id, :released_at]
  end

  private :music_entity_name, :music_entity_attributes
end
