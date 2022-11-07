require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    mock_successful_authentication(regional_delivery_officer.email)
    allow_any_instance_of(ProjectsController).to receive(:user_id).and_return(regional_delivery_officer.id)
  end

  describe "#create" do
    let(:project_form) { ProjectForm.new }
    let(:project_params) { attributes_for(:project).except(:team_leader, :regional_delivery_officer) }
    let(:note_params) { {body: "new note"} }
    let!(:team_leader) { create(:user, :team_leader) }

    subject(:perform_request) do
      post projects_path, params: {project_form: {**project_params, note: note_params}}
      response
    end

    context "when the project is not valid" do
      before do
        allow(ProjectForm).to receive(:new).and_return(project_form)
        allow(project_form).to receive(:valid?).and_return false
      end

      it "re-renders the new template" do
        expect(perform_request).to render_template :new
      end
    end

    context "when the project is valid" do
      let(:mock_project_creator) { ProjectCreator.new }
      let(:project_form) { ProjectForm.new(**project_params, regional_delivery_officer_id: regional_delivery_officer.id) }
      let(:note_form) { NoteForm.new(**note_params, user_id: regional_delivery_officer.id) }

      before do
        allow(ProjectCreator).to receive(:new).and_return(mock_project_creator)
        allow(mock_project_creator).to receive(:call).and_return create(:project)

        perform_request
      end

      it "calls the TaskListCreator" do
        expect(mock_project_creator).to have_received(:call).with(have_attributes(project_form.attributes), have_attributes(note_form.attributes))
      end
    end
  end
end
