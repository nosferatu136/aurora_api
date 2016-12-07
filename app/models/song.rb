class Song < ActiveRecord::Base
  include RequiresArtist
  include AssignsGuid

  attr_accessible :name, :duration, :artist_id

  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :playlist_songs, dependent: :destroy
  has_many :albums, through: :album_songs
  has_many :playlists, through: :playlist_songs

  validates :name, :duration, :artist_id, presence: true
  validate  :artist_presence
end
