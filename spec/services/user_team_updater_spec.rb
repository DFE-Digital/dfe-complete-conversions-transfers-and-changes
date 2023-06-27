require "rails_helper"

RSpec.describe UserTeamUpdater do
  let(:updater) { described_class.new(user: user) }
  let(:user) { create(:user, :caseworker) }

  describe "#update!" do
    context "when the user is service_support" do
      let(:user) { create(:user, team: nil, service_support: true) }

      it "sets the team to be service_support" do
        updater.update!
        expect(user.team).to eq("service_support")
      end
    end

    context "when the user is a caseworker" do
      let(:user) { create(:user, team: nil, caseworker: true) }

      it "sets the team to be regional_casework_services" do
        updater.update!
        expect(user.team).to eq("regional_casework_services")
      end
    end

    context "when the user is team_leader" do
      let(:user) { create(:user, team: nil, team_leader: true) }

      it "sets the team to be regional_casework_services" do
        updater.update!
        expect(user.team).to eq("regional_casework_services")
      end
    end

    context "when the user is a regional_delivery_officer" do
      let(:user) { create(:user, team: nil, regional_delivery_officer: true) }

      it "does not set the team" do
        updater.update!
        expect(user.team).to be_nil
      end
    end

    context "when the user has no role" do
      let(:user) { create(:user, team: nil, caseworker: false, regional_delivery_officer: false, team_leader: false) }

      it "does not set the team" do
        updater.update!
        expect(user.team).to be_nil
      end
    end

    it "raises an error when the transaction fails for any reason" do
      allow(user).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)

      expect { updater.update! }.to raise_error(UserTeamUpdater::UserTeamError)
        .with_message("Unable to update team for user #{user.id}")
    end
  end
end
