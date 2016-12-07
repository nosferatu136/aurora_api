class Playlist < ActiveRecord::Base
  include HasSongs
  include AssignsGuid

  attr_accessible :name, :user_id

  has_many   :playlist_songs
  has_many   :songs, through: :playlist_songs

  validates :name, :user_id, presence: true
end
