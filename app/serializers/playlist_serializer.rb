class PlaylistSerializer < ActiveModel::Serializer
  attributes :guid, :name, :user_id

  has_many :songs, serializer: SongWithoutArtistSerializer
end
