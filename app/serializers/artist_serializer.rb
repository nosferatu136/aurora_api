class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :alias

  has_many :albums, serializer: AlbumWithoutArtistSerializer
end
