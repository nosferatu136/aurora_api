class Album < ActiveRecord::Base
  include RequiresArtist

  attr_accessible :name, :artist_id, :art_id, :released_at

  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  validates :name, :artist_id, :released_at, presence: true
  validate  :artist_presence

  # -1 this would be a great place to handle adding/removing songs from the album, instead of in the
  # controllers or via helper methods. Since song album membership is a concern of data model, not
  # of controllers
end
