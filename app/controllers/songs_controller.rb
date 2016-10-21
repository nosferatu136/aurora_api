class SongsController < CommonMusicController

  private def music_entity_name
    :song
  end

  private def music_entity_attributes
    [:name, :duration, :artist_id]
  end
end
