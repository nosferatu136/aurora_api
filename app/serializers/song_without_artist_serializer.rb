class SongWithoutArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :duration, :artist_id
end
