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

  class AlbumSongProcessor
    attr_reader :album_id, :song_ids, :action

    def initialize(params, action)
      @album_id = params[:album_id]
      @song_ids = params[:song_ids]
      @action = action
    end

    def process
      if album
        if action == :add
          album_song_ids = album.songs.pluck(:id)
          songs_to_add_ids = song_ids.map(&:to_i) - album_song_ids
          Song.where(id: songs_to_add_ids).each do |song|
            album.album_songs.create(song_id: song.id)
          end
        else
          AlbumSong.where(album_id: album_id, song_id: song_ids).delete_all
        end
      end
      self
    end

    def album
      return @album if defined?(@album)
      @album = Album.find_by_id(album_id)
    end

    def status
      return :not_found unless album
      errors.any? ? :unprocessable_entity : :ok
    end

    def errors
      return [] unless album
      album.reload.errors.full_messages
    end
  end
end
