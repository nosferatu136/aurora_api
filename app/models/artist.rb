class Artist < ActiveRecord::Base
  attr_accessible :name, :bio, :alias

  validates :name, presence: true
end