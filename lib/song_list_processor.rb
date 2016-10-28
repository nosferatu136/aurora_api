class SongListProcessor
  attr_reader :music_object_id, :song_ids, :action, :type

  def initialize(params, action)
    @music_object_id = params["#{type}_id".to_sym]
    @song_ids = params[:song_ids]
    @action = action
  end

  def process
    if music_object
      if action == :add
        music_object_song_ids = music_object.songs.pluck(:id)
        songs_to_add_ids = song_ids.map(&:to_i) - music_object_song_ids
        Song.where(id: songs_to_add_ids).each do |song|
          music_object.method(music_object_songs).call.create(song_id: song.id)
        end
      else
        music_object_songs_class.where("#{type}_id".to_sym => music_object_id, song_id: song_ids)
                                .delete_all
      end
    end
    self
  end

  def music_object
    return @music_object if defined?(@music_object)
    @music_object = music_object_class.find_by_id(music_object_id)
  end

  private def music_object_songs
    "#{music_object_songs_class}s".underscore.to_sym
  end

  private def music_object_songs_class
    "#{type}Song".classify.constantize
  end

  private def music_object_class
    type.to_s.capitalize.constantize
  end

  def status
    return :not_found unless music_object
    errors.any? ? :unprocessable_entity : :ok
  end

  def errors
    return [] unless music_object
    music_object.reload.errors.full_messages
  end
end
