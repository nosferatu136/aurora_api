class ArtistWithoutAlbumsSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :alias
end
