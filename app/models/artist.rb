class Artist < ActiveRecord::Base
  attr_accessible :name, :bio, :alias

  has_many :songs, dependent: :destroy
  has_many :albums, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name
end