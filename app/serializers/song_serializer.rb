class SongSerializer < ActiveModel::Serializer
  attributes :id, :name, :duration

  has_one :artist, serializer: ArtistWithoutAlbumsSerializer
end
