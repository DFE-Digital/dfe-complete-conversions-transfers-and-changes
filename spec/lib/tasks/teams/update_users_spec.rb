require "rails_helper"

RSpec.describe "rake update_teams:users", type: :task do
  subject { Rake::Task["update_teams:users"] }

  let(:mock_user_team_updater) { double(UserTeamUpdater, update!: true) }

  before do
    allow(UserTeamUpdater).to receive(:new).and_return(mock_user_team_updater)
  end

  let!(:user) { create(:user, team: nil, caseworker: true) }

  it "calls UserTeamUpdater service on all users" do
    subject.invoke
    expect(mock_user_team_updater).to have_received(:update!)
  end
end
