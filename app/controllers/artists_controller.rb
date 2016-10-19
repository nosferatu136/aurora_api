class ArtistsController < ApplicationController

  before_filter :assign_artist, only: [:index, :update, :destroy]

  def index
    render json: Artist.all
  end

  def create
    artist = Artist.new(artist_params(params))
    status =  artist.save ? :ok : :unprocessable_entity
    render json: { artist: artist, errors: artist.errors.full_messages }, status: status
  end

  def update
    status =  if @artist.nil?
                :not_found
              else
                @artist.update_attributes(artist_params(params)) ? :ok : :unprocessable_entity
              end
    errors = @artist.nil? ? [] : @artist.errors.full_messages
    render json: { artist: @artist, errors: errors }, status: status
  end

  def destroy
    status =  if @artist.nil?
                :not_found
              else
                @artist.destroy ? :ok : :unprocessable_entity
              end
    render json: {}, status: status
  end

  private def assign_artist
    @artist = Artist.find_by_id(params[:id])
  end

  private def artist_params(params)
    params.slice(:name, :bio, :alias)
  end
end
