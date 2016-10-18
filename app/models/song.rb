class Song < ActiveRecord::Base
  attr_accessible :name, :duration, :artist_id

  belongs_to :artist

  validates :name, :duration, presence: true
end