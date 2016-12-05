class CommonMusicController < ApplicationController

  before_filter :assign_music_entity, only: [:show, :update, :destroy]

  def index
    render json: music_entity_class.all
  end

  def show
    # 0 :not_found could be defined as a class constant, ensuring that you're using the same
    # value everywhere. right now if there's a typo status could be set to "nit_found" etc.
    # same feedback for other statuses like :ok and :unprocessable_entity
    status = @music_entity.present? ? :ok : :not_found
    render json: { music_entity_name => @music_entity }, status: status
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

  # 0 alternative way of expressing private/protected: http://stackoverflow.com/questions/10724221/where-to-place-private-methods-in-ruby
  # not better or worse, just FYI
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
