module HasSongLists
  def add_songs
    status = process_request(:add_songs)
    render json: { playlist: @music_entity, errors: errors }, status: status
  end

  def remove_songs
    status = process_request(:remove_songs)
    render json: { playlist: @music_entity, errors: errors }, status: status
  end

  def process_request(request_type)
    if @music_entity.present?
      @music_entity.send(request_type, params[:song_guids])
      CommonMusicController::SUCCESS
    else
      CommonMusicController::NOT_FOUND
    end
  end

  def errors
    (@music_entity && @music_entity.errors.full_messages) || []
  end
end
