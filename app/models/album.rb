class Album < ActiveRecord::Base
  include HasSongs
  include RequiresArtist
  include AssignsGuid

  attr_accessible :name, :artist_id, :art_id, :released_at, :artist_guid

  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  before_validation :associate_artist_from_guid

  validates :name, :artist_id, :released_at, presence: true
  validate  :artist_presence

  def artist_guid=(value)
    @artist_guid = value
  end

  def artist_guid
    @artist_guid || artist && artist.guid
  end
end
