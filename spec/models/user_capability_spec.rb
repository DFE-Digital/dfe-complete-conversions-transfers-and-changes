require "rails_helper"

RSpec.describe UserCapability do
  it { is_expected.to belong_to(:user).optional(false) }
  it { is_expected.to belong_to(:capability).optional(false) }
end
