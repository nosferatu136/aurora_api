module HasSongs
  def add_songs(song_ids)
    Song.where(id: songs_to_add_ids(song_ids)).each do |song|
      method(object_songs).call.create(song_id: song.id)
    end
  end

  def remove_songs(song_ids)
    songs_to_remove = method(object_songs).call
    songs_to_remove = songs_to_remove.where(song_id: song_ids) if song_ids.present?
    songs_to_remove.delete_all
  end

  def songs_to_add_ids(song_ids)
    song_ids.map(&:to_i) - songs.pluck(:id)
  end

  def object_songs
    "#{song_list_class}s".underscore.to_sym
  end

  def song_list_class
    "#{self.class}Song".classify.constantize
  end

  private :songs_to_add_ids, :song_list_class, :object_songs
end
