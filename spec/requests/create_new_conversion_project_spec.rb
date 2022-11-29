require "rails_helper"

RSpec.describe "Create new conversion project" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  before { mock_successful_authentication(regional_delivery_officer.email) }

  context "when the project type is involuntary" do
    before { allow_any_instance_of(Conversion::Involuntary::ProjectsController).to receive(:user_id).and_return(regional_delivery_officer.id) }

    describe "#create" do
      let(:project) { build(:project, type: "Conversion::Project") }
      let(:note_params) { {body: "new note"} }
      let!(:team_leader) { create(:user, :team_leader) }

      subject(:perform_request) do
        post conversion_involuntary_new_path, params: {conversion_project: {**project_params, note: note_params}}
        response
      end

      context "when the conversion project is valid" do
        let(:project_params) { attributes_for(:project, regional_delivery_officer: nil) }
        let(:task_list_creator) { TaskListCreator.new }
        let(:new_project_record) { Project.last }

        before do
          mock_successful_api_responses(urn: 123456, ukprn: 10061021)

          allow(TaskListCreator).to receive(:new).and_return(task_list_creator)
          allow(task_list_creator).to receive(:call).and_return true

          perform_request
        end

        it "creates a new conversion project, involuntary details and note" do
          expect(Conversion::Project.count).to be 1
          expect(Conversion::Involuntary::Details.count).to be 1
          expect(Note.count).to be 1
          expect(Note.last.user).to eq regional_delivery_officer
        end
      end

      context "when some required project information is not valid" do
        let(:project_params) { attributes_for(:project, establishment_sharepoint_link: nil, trust_sharepoint_link: nil, regional_delivery_officer: nil) }
        let(:task_list_creator) { TaskListCreator.new }

        subject(:perform_request) do
          post conversion_involuntary_new_path, params: {conversion_project: {**project_params, note: note_params}}
          response
        end

        before do
          mock_successful_api_responses(urn: 123456, ukprn: 10061021)

          allow(TaskListCreator).to receive(:new).and_return(task_list_creator)
          allow(task_list_creator).to receive(:call).and_return true

          perform_request
        end

        it "does not create a conversion project" do
          expect(Conversion::Project.count).to be 0
          expect(Conversion::Involuntary::Details.count).to be 0
          expect(Note.count).to be 0
        end
      end
    end
  end

  context "when the project type is voluntary" do
    before { allow_any_instance_of(Conversion::Voluntary::ProjectsController).to receive(:user_id).and_return(regional_delivery_officer.id) }

    describe "#create" do
      let(:project) { build(:project, type: "Conversion::Project") }
      let(:project_params) { attributes_for(:project, regional_delivery_officer: nil) }
      let(:note_params) { {body: "new note"} }
      let!(:team_leader) { create(:user, :team_leader) }

      subject(:perform_request) do
        post conversion_voluntary_new_path, params: {conversion_project: {**project_params, note: note_params}}
        response
      end

      context "when the conversion project is valid" do
        let(:task_list_creator) { TaskListCreator.new }
        let(:new_project_record) { Project.last }

        before do
          mock_successful_api_responses(urn: 123456, ukprn: 10061021)

          allow(TaskListCreator).to receive(:new).and_return(task_list_creator)
          allow(task_list_creator).to receive(:call).and_return true

          perform_request
        end

        it "creates a new conversion project, voluntary details and note" do
          expect(Conversion::Project.count).to be 1
          expect(Conversion::Voluntary::Details.count).to be 1
          expect(Note.count).to be 1
          expect(Note.last.user).to eq regional_delivery_officer
        end
      end

      context "when some required project information is not valid" do
        let(:project_params) { attributes_for(:project, establishment_sharepoint_link: nil, trust_sharepoint_link: nil, regional_delivery_officer: nil) }
        let(:task_list_creator) { TaskListCreator.new }

        subject(:perform_request) do
          post conversion_voluntary_new_path, params: {conversion_project: {**project_params, note: note_params}}
          response
        end

        before do
          mock_successful_api_responses(urn: 123456, ukprn: 10061021)

          allow(TaskListCreator).to receive(:new).and_return(task_list_creator)
          allow(task_list_creator).to receive(:call).and_return true

          perform_request
        end

        it "does not create a conversion project" do
          expect(Conversion::Project.count).to be 0
          expect(Conversion::Involuntary::Details.count).to be 0
          expect(Note.count).to be 0
        end
      end
    end
  end
end
