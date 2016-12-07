module AssignsGuid
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_create :assign_guid
  end

  def assign_guid
    self.guid = SecureRandom.uuid unless guid.present?
  end
end
