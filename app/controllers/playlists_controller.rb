class PlaylistsController < CommonMusicController
  include HasSongLists

  before_filter :assign_music_entity, only: [:add_songs, :remove_songs, :show, :update, :destroy]

  def music_entity_name
    :playlist
  end

  def music_entity_attributes
    [:name, :user_id]
  end

  private :music_entity_name, :music_entity_attributes, :process_request, :errors
end
