class Album < ActiveRecord::Base
  attr_accessible :name, :artist_id, :art_id, :released_at

  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  validates :name, :artist_id, :released_at, presence: true
end