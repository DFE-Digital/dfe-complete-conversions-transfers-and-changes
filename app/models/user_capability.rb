class UserCapability < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :capability, required: true

  def self.has_capability?(user:, capability_name:)
    capability = Capability.find_by(name: capability_name)
    return false unless capability

    user.capabilities.include?(capability)
  end
end
