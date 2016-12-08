class CommonMusicController < ApplicationController
  SUCCESS       = :ok
  NOT_FOUND     = :not_found
  UNPROCESSABLE = :unprocessable_entity

  before_filter :assign_music_entity, only: [:show, :update, :destroy]

  def index
    render json: music_entity_class.all
  end

  def show
    status = @music_entity.present? ? SUCCESS : NOT_FOUND
    render json: { music_entity_name => @music_entity }, status: status
  end

  def create
    new_entity = music_entity_class.new(music_entity_params(params))
    status =  new_entity.save ? SUCCESS : UNPROCESSABLE
    render json: { music_entity_name => new_entity, errors: new_entity.errors.full_messages }, status: status
  end

  def update
    status =  if @music_entity.nil?
                NOT_FOUND
              else
                @music_entity.update_attributes(music_entity_params(params)) ? SUCCESS : UNPROCESSABLE
              end
    errors = @music_entity.nil? ? [] : @music_entity.errors.full_messages
    render json: { music_entity_name => @music_entity, errors: errors }, status: status
  end

  def destroy
    status =  if @music_entity.nil?
                NOT_FOUND
              else
                @music_entity.destroy ? SUCCESS : UNPROCESSABLE
              end
    render json: {}, status: status
  end

  def assign_music_entity
    @music_entity = music_entity_class.find_by_guid(params[:guid] || params["#{music_entity_name}_guid".to_sym])
  end

  def music_entity_params(params)
    params.slice(*music_entity_attributes)
  end

  def music_entity_class
    music_entity_name.to_s.capitalize.constantize
  end

  def music_entity_name
    raise NotImplementedException
  end

  def music_entity_attributes
    raise NotImplementedException
  end

  private :assign_music_entity, :music_entity_params, :music_entity_class, :music_entity_name,
          :music_entity_attributes
end
