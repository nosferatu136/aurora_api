class PlaylistsController < CommonMusicController

  def add_songs
    processor = PlaylistSongProcessor.new(params.slice(:playlist_id, :song_ids), :add).process
    render json: { playlist: processor.playlist, errors: processor.errors }, status: processor.status
  end

  def remove_songs
    processor = PlaylistSongProcessor.new(params.slice(:playlist_id, :song_ids), :remove).process
    render json: { playlist: processor.playlist, errors: processor.errors }, status: processor.status
  end

  private def music_entity_name
    :playlist
  end

  private def music_entity_attributes
    [:name, :user_id]
  end

  class PlaylistSongProcessor < SongListProcessor
    def initialize(params, action)
      @type = :playlist
      super
    end
  end
end
