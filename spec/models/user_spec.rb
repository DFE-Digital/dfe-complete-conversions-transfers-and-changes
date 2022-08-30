require "rails_helper"

RSpec.describe User do
  describe "Columns" do
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:first_name).of_type :string }
    it { is_expected.to have_db_column(:last_name).of_type :string }
    it { is_expected.to have_db_column(:team_leader).of_type :boolean }
    it { is_expected.to have_db_column(:regional_delivery_officer).of_type :boolean }
  end

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
