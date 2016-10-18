class Song < ActiveRecord::Base
  attr_accessible :name, :duration, :artist_id

  belongs_to :artist
  has_many :album_songs
  has_many :playlist_songs
  has_many :albums, through: :album_songs
  has_many :playlists, through: :playlist_songs

  validates :name, :duration, presence: true
end