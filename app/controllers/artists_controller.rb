class ArtistsController < CommonMusicController

  private def music_entity_name
    :artist
  end

  private def music_entity_attributes
    [:name, :bio, :alias]
  end
end
