class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :art_id, :released_at

  has_one :artist, serializer: ArtistWithoutAlbumsSerializer
  has_many :songs, serializer: SongWithoutArtistSerializer
end
