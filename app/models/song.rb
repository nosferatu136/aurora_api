class Song < ActiveRecord::Base
  include RequiresArtist
  include AssignsGuid

  attr_accessible :name, :duration, :artist_id, :artist_guid
  attr_accessor :artist_guid

  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :playlist_songs, dependent: :destroy
  has_many :albums, through: :album_songs
  has_many :playlists, through: :playlist_songs

  before_validation :associate_artist_from_guid

  validates :name, :duration, :artist_id, presence: true
  validate  :artist_presence
end
