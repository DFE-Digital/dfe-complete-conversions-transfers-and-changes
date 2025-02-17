require "rails_helper"

RSpec.describe UserCapability do
  it { is_expected.to belong_to(:user).optional(false) }
  it { is_expected.to belong_to(:capability).optional(false) }

  describe "#has_capability?(user:, capability:)" do
    let(:capability) do
      Capability.create(name: :add_project, description: "May create projects")
    end

    let(:other_capability) do
      Capability.create(name: :superpower, description: "May wield superpower")
    end

    let(:user) { create(:user) }

    before do
      user.capabilities << capability
    end

    it "returns true when the capability is present" do
      expect(UserCapability.has_capability?(user: user, capability_name: :add_project)).to be true
    end

    it "returns false when the capability is NOT present" do
      expect(UserCapability.has_capability?(user: user, capability_name: :superpower)).to be false
    end

    it "returns false when the capability does not exist" do
      expect(UserCapability.has_capability?(user: user, capability_name: :missing_capability)).to be false
    end
  end
end
