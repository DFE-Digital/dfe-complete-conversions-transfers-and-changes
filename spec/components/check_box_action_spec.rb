require "rails_helper"

RSpec.describe TaskList::CheckBoxAction, type: :component do
  let(:task) { double(status: :not_started, locales_path: "conversion.voluntary.tasks.handover") }

  before do
    allow(task).to receive(attribute.to_sym).and_return(true)
  end

  context "when the checkbox only has a title" do
    let(:attribute) { "notes" }

    it "renders the title" do
      render_inline(TaskList::CheckBoxAction.new(task: task, attribute: attribute))

      expect(page).to have_text("Make notes and write questions to as the regional delivery officer")
    end
  end

  context "when the checkbox has a title and hint" do
    let(:attribute) { "meeting" }

    it "renders the title and hint" do
      render_inline(TaskList::CheckBoxAction.new(task: task, attribute: attribute))

      expect(page).to have_text("Attend handover meeting with regional delivery officer")
      expect(page).to have_text("Discuss any questions you have about the project in the meeting.")
    end
  end

  context "when the checkbox has a title, hint and guidance" do
    let(:attribute) { "review" }

    it "renders the title, hint and guidance" do
      render_inline(TaskList::CheckBoxAction.new(task: task, attribute: attribute))

      expect(page).to have_text("Review the project information, check the documents and carry out research")
      expect(page).to have_text("Check that no information is missing from the existing project documents and there are no errors.")
      expect(page).to have_text("Things to check during your background research include:")
    end
  end

  context "when the checkbox task is a 'Conversion::Voluntary' task" do
    let(:attribute) { "notes" }

    before do
      allow(task).to receive_message_chain("class.name").and_return("Conversion::Voluntary::Tasks::Handover")
    end

    it "renders the correct `name` for the form input" do
      render_inline(TaskList::CheckBoxAction.new(task: task, attribute: attribute))

      expect(page.find("//input[1]/@name").text).to eq("conversion_voluntary_tasks_handover[notes]")
    end
  end
end
