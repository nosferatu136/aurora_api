class CommonMusicController < ApplicationController

  before_filter :assign_music_entity, only: [:index, :update, :destroy]

  def index
    render json: music_entity_class.all
  end

  def create
    new_entity = music_entity_class.new(music_entity_params(params))
    status =  new_entity.save ? :ok : :unprocessable_entity
    render json: { music_entity_name => new_entity, errors: new_entity.errors.full_messages }, status: status
  end

  def update
    status =  if @music_entity.nil?
                :not_found
              else
                @music_entity.update_attributes(music_entity_params(params)) ? :ok : :unprocessable_entity
              end
    errors = @music_entity.nil? ? [] : @music_entity.errors.full_messages
    render json: { music_entity_name => @music_entity, errors: errors }, status: status
  end

  def destroy
    status =  if @music_entity.nil?
                :not_found
              else
                @music_entity.destroy ? :ok : :unprocessable_entity
              end
    render json: {}, status: status
  end

  private def assign_music_entity
    @music_entity =  music_entity_class.find_by_id(params[:id])
  end

  private def music_entity_params(params)
    params.slice(*music_entity_attributes)
  end

  private def music_entity_class
    music_entity_name.to_s.capitalize.constantize
  end

  private def music_entity_name
    raise NotImplementedException
  end

  private def music_entity_attributes
    raise NotImplementedException
  end
end
