require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_successful_authentication(team_leader.email)
    allow_any_instance_of(ProjectsController).to receive(:user_id).and_return(team_leader.id)
  end

  describe "#create" do
    subject(:perform_request) do
      post projects_path, params: {project: {urn: 123456}}
      response
    end

    context "when the project is not valid" do
      let(:project) { build(:project, team_leader: nil) }

      before do
        allow(Project).to receive(:new).and_return(project)
        allow(project).to receive(:valid?).and_return false
      end

      it "re-renders the new template" do
        expect(perform_request).to render_template :new
      end
    end

    context "when the project is valid" do
      let(:project) { build(:project, team_leader: nil) }

      before do
        mock_successful_api_responses(urn: 123456, ukprn: 10061021)
        allow(Project).to receive(:new).and_return(project)
        allow(project).to receive(:valid?).and_return(true)
      end

      it "assigns the team leader, calls the TaskListCreator, and redirects to the project path" do
        expect_any_instance_of(TaskListCreator).to receive(:call).with(project)
        expect(perform_request).to redirect_to(project_path(project.id))
        expect(project.team_leader_id).to eq team_leader.id
      end
    end
  end
end
