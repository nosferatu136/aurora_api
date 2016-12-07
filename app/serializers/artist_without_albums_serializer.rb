class ArtistWithoutAlbumsSerializer < ActiveModel::Serializer
  attributes :guid, :name, :bio, :alias
end
