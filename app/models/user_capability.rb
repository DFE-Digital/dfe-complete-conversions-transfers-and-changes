class UserCapability < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :capability, required: true
end
