class SongWithoutArtistSerializer < ActiveModel::Serializer
  attributes :guid, :name, :duration, :artist_guid
end
