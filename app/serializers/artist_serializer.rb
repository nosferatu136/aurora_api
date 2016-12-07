class ArtistSerializer < ActiveModel::Serializer
  attributes :guid, :name, :bio, :alias

  has_many :albums, serializer: AlbumWithoutArtistSerializer
end
