require "rails_helper"

RSpec.describe User do
  describe "scopes" do
    describe "caseworkers" do
      it "only includes users that are not team lead or regional delivery officer" do
        caseworker = create(:user, :caseworker)
        team_lead = create(:user, :team_leader)
        regional_delivery_officer = create(:user, :regional_delivery_officer)

        caseworkers = User.caseworkers

        expect(caseworkers).not_to include team_lead
        expect(caseworkers).not_to include regional_delivery_officer
        expect(caseworkers).to include caseworker
      end
    end
  end
end
