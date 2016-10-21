class SongsController < ApplicationController

  before_filter :assign_song, only: [:index, :update, :destroy]

  def index
    render json: Song.all
  end

  def create
    artist = Song.new(song_params(params))
    status =  artist.save ? :ok : :unprocessable_entity
    render json: { artist: artist, errors: artist.errors.full_messages }, status: status
  end

  def update
    status =  if @song.nil?
                :not_found
              else
                @song.update_attributes(song_params(params)) ? :ok : :unprocessable_entity
              end
    errors = @song.nil? ? [] : @song.errors.full_messages
    render json: { artist: @song, errors: errors }, status: status
  end

  def destroy
    status =  if @song.nil?
                :not_found
              else
                @song.destroy ? :ok : :unprocessable_entity
              end
    render json: {}, status: status
  end

  private def assign_song
    @song = Song.find_by_id(params[:id])
  end

  private def song_params(params)
    params.slice(:name, :duration, :artist_id)
  end
end
