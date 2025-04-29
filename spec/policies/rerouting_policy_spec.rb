require "rails_helper"

RSpec.describe ReroutingPolicy do
  describe "#show?" do
    context "when the user is a member of the 'service_support' team" do
      let(:user) { build(:user, team: "service_support") }

      it "permits access" do
        expect(ReroutingPolicy.new(user).show?).to be true
      end
    end

    context "when the user is NOT a member of the 'service_support' team" do
      let(:user) { build(:user, team: "south_west") }

      it "DENIES access" do
        expect(ReroutingPolicy.new(user).show?).to be false
      end

      context "when the user has the 'devops' user capability" do
        before { user.capabilities << Capability.devops }

        it "permits access" do
          expect(ReroutingPolicy.new(user).show?).to be true
        end
      end
    end
  end
end
