require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_successful_authentication(team_leader.email)
    allow_any_instance_of(ProjectsController).to receive(:user_id).and_return(team_leader.id)
  end

  describe "#create" do
    subject(:perform_request) do
      post projects_path, params: {project: {urn: 12345}}
      response
    end

    context "when the project is valid" do
      let(:project) { build(:project, team_leader: nil) }

      before do
        mock_successful_api_responses(urn: 12345)
        allow(Project).to receive(:new).and_return(project)
      end

      it "assigns the team leader, calls the TaskListCreator, and redirects to the project path" do
        expect_any_instance_of(TaskListCreator).to receive(:call).with(project)
        expect(subject).to redirect_to(project_path(project.id))
        expect(project.team_leader_id).to eq team_leader.id
      end
    end
  end
end
