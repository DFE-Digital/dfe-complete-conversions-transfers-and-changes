require "rails_helper"

RSpec.describe "rake update_teams:projects", type: :task do
  subject { Rake::Task["update_teams:projects"] }

  let(:mock_project_team_updater) { double(ProjectTeamUpdater, update!: true) }

  before do
    allow(ProjectTeamUpdater).to receive(:new).and_return(mock_project_team_updater)
    mock_successful_api_response_to_create_any_project
  end

  let!(:project) { create(:conversion_project) }

  it "calls ProjectTeamUpdater service on all projects" do
    subject.invoke
    expect(mock_project_team_updater).to have_received(:update!)
  end
end
