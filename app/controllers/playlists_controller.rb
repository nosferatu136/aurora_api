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

  class PlaylistSongProcessor
    attr_reader :playlist_id, :song_ids, :action

    def initialize(params, action)
      @playlist_id = params[:playlist_id]
      @song_ids = params[:song_ids]
      @action = action
    end

    def process
      if playlist
        if action == :add
          playlist_song_ids = playlist.songs.pluck(:id)
          songs_to_add_ids = song_ids.map(&:to_i) - playlist_song_ids
          Song.where(id: songs_to_add_ids).each do |song|
            playlist.playlist_songs.create(song_id: song.id)
          end
        else
          PlaylistSong.where(playlist_id: playlist_id, song_id: song_ids).delete_all
        end
      end
      self
    end

    def playlist
      return @playlist if defined?(@playlist)
      @playlist = Playlist.find_by_id(playlist_id)
    end

    def status
      return :not_found unless playlist
      errors.any? ? :unprocessable_entity : :ok
    end

    def errors
      return [] unless playlist
      playlist.reload.errors.full_messages
    end
  end
end
