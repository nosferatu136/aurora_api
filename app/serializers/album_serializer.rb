# 0 GrapeEntity is a great alternative to ActiveModel::Serializer. It's not better or worse, but many
#   prefer its delcarative style, and it works well w/ Grape if you're using it already (We use Grape + GrapeEntity)
class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :art_id, :released_at

  has_one :artist, serializer: ArtistWithoutAlbumsSerializer
  has_many :songs, serializer: SongWithoutArtistSerializer
end
