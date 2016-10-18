class AlbumSong < ActiveRecord::Base
  attr_accessible :album_id, :song_id

  belongs_to :album
  belongs_to :song

  validates :album_id, :song_id, presence: true
end