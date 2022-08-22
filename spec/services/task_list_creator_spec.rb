require "rails_helper"

RSpec.describe TaskListCreator do
  let(:task_list_creator) { TaskListCreator.new }
  let(:mock_workflow) { file_fixture("workflows/conversion.yml") }
  let(:workflow_path) { Rails.root.join("app", "workflows", "conversion.yml") }

  before do
    allow(YAML).to receive(:load_file).with(workflow_path).and_return(
      YAML.load_file(mock_workflow)
    )

    mock_successful_api_responses(urn: 12345, ukprn: 10061021)
  end

  describe "#call" do
    let(:project) { create(:project) }

    subject! { task_list_creator.call(project) }

    it "loads the YAML workflow" do
      expect(YAML).to have_received(:load_file).with(workflow_path).once
    end

    it "creates sections from the workflow" do
      expect(Section.count).to be 2
      expect(Section.where(title: "Starting the project", order: 0, project: project)).to exist
    end

    it "creates tasks from the workflow" do
      section = Section.find_by(title: "Starting the project")

      expect(Task.count).to be 3
      expect(
        Task.where(
          title: "Understand history and complete handover from Pre-AB",
          order: 0,
          hint: "Understand history hint",
          guidance_summary: "Understand history guidance summary",
          guidance_text: "Understand history guidance text",
          section: section
        )
      ).to exist
    end

    it "creates actions from the workflow" do
      section = Section.find_by(title: "Starting the project")
      task = section.tasks.find_by(title: "Understand history and complete handover from Pre-AB")

      expect(Action.count).to eql 6
      expect(
        Action.where(
          title: "Action one",
          order: 0,
          hint: "Action one hint",
          guidance_summary: "Action one guidance summary",
          guidance_text: "Action one guidance text",
          task: task
        )
      ).to exist
    end

    context "when the workflow's optional fields are empty" do
      it "creates tasks from the workflow" do
        section = Section.find_by(title: "Clear legal documents")

        expect(Task.count).to be 3
        expect(
          Task.where(
            title: "Clear land questionnaire",
            order: 0,
            hint: nil,
            guidance_summary: nil,
            guidance_text: nil,
            section: section
          )
        ).to exist
      end

      it "creates actions from the workflow" do
        section = Section.find_by(title: "Clear legal documents")
        task = section.tasks.find_by(title: "Clear land questionnaire")

        expect(
          Action.where(
            title: "Action one",
            order: 0,
            hint: nil,
            guidance_summary: nil,
            guidance_text: nil,
            task: task
          )
        ).to exist
      end
    end
  end
end
