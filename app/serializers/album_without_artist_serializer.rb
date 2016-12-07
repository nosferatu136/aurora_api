class AlbumWithoutArtistSerializer < ActiveModel::Serializer
  attributes :guid, :name, :art_id, :artist_id, :released_at

  has_many :songs, serializer: SongWithoutArtistSerializer
end
