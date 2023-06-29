require "rails_helper"

RSpec.describe ProjectTeamUpdater, :skip do
  let(:user) { create(:user, :caseworker) }
  let(:region) { "yorkshire_and_the_humber" }
  let(:assigned_to_regional_caseworker_team) { false }
  let(:project) { create(:conversion_project, team: nil, region: region, assigned_to_regional_caseworker_team: assigned_to_regional_caseworker_team) }
  let(:updater) { described_class.new(project: project) }

  before do
    mock_successful_api_calls(establishment: any_args, trust: any_args)
  end

  describe "#update" do
    context "when the project has a region set and assigned_to_regional_caseworker_team is false" do
      it "sets the team to match the region" do
        updater.update!
        expect(project.team).to eq("yorkshire_and_the_humber")
      end
    end

    context "when when the project has a region set and assigned_to_regional_caseworker_team is true" do
      let(:region) { "west_midlands" }
      let(:assigned_to_regional_caseworker_team) { true }

      it "sets the team to regional_casework_services" do
        updater.update!
        expect(project.team).to eq("regional_casework_services")
      end
    end

    context "when the project has no region set and assigned_to_regional_caseworker_team is false" do
      let(:region) { nil }
      let(:assigned_to_regional_caseworker_team) { false }

      it "raises an error" do
        expect { updater.update! }.to raise_error(ProjectTeamUpdater::ProjectTeamError)
          .with_message("Project region is nil, project_id: #{project.id}")
      end
    end

    it "raises an error when the transaction fails for any reason" do
      allow(project).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)

      expect { updater.update! }.to raise_error(ProjectTeamUpdater::ProjectTeamError)
        .with_message("Project team update failed, project_id: #{project.id}")
    end
  end
end
