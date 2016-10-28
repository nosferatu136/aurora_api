class AlbumsController < CommonMusicController

  def add_songs
    processor = AlbumSongProcessor.new(params.slice(:album_id, :song_ids), :add).process
    render json: { album: processor.album, errors: processor.errors }, status: processor.status
  end

  def remove_songs
    processor = AlbumSongProcessor.new(params.slice(:album_id, :song_ids), :remove).process
    render json: { album: processor.album, errors: processor.errors }, status: processor.status
  end

  private def music_entity_name
    :album
  end

  private def music_entity_attributes
    [:name, :artist_id, :art_id, :released_at]
  end

  class AlbumSongProcessor < ::SongListProcessor
    def initialize(params, action)
      @type = :album
      super
    end
  end
end
