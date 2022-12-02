require "rails_helper"

RSpec.describe TaskListCreator do
  let(:task_list_creator) { TaskListCreator.new }
  let(:mock_workflow_root) { Rails.root.join("spec", "fixtures", "files", "workflows", "conversion") }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  describe "#call" do
    let(:project) { create(:conversion_project) }

    subject! { task_list_creator.call(project, workflow_root: mock_workflow_root) }

    it "creates sections from the workflow" do
      expect(Section.count).to be 2
      expect(Section.where(title: "Starting the project", order: 0, project: project)).to exist
    end

    it "creates tasks from the workflow" do
      section = Section.find_by(title: "Starting the project")

      expect(Task.count).to be 3
      expect(
        Task.where(
          slug: "handover-from-pre-ab",
          title: "Understand history and complete handover from Pre-AB",
          order: 0,
          hint: "Understand history hint",
          guidance_summary: "Understand history guidance summary",
          guidance_text: "Understand history guidance text",
          section: section
        )
      ).to exist
    end

    it "creates optional tasks" do
      expect(Task.where(title: "Optional note concerns or issues from handover", optional: true)).to exist
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
        section = Section.find_by(title: "Clear and sign legal documents")

        expect(Task.count).to be 3
        expect(
          Task.where(
            slug: "clear-land-questionnaire",
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
        section = Section.find_by(title: "Clear and sign legal documents")
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
