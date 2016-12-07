class SongSerializer < ActiveModel::Serializer
  attributes :guid, :name, :duration

  has_one :artist, serializer: ArtistWithoutAlbumsSerializer
end
