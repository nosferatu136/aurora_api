class Artist < ActiveRecord::Base
  attr_accessible :name, :bio, :alias

  has_many :songs, dependent: :destroy

  validates :name, presence: true
end