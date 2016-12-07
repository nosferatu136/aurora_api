class SongWithoutArtistSerializer < ActiveModel::Serializer
  attributes :guid, :name, :duration, :artist_id
end
