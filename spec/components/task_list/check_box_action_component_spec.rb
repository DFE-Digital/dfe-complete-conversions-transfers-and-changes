require "rails_helper"

RSpec.describe TaskList::CheckBoxActionComponent, type: :component do
  let(:task) { double(status: :not_started, locales_path: "conversion.task.handover") }

  before do
    allow(task).to receive(attribute.to_sym).and_return(true)
    render_inline(TaskList::CheckBoxActionComponent.new(task: task, attribute: attribute))
  end

  context "when the checkbox only has a title" do
    let(:attribute) { "notes" }

    it "renders the title" do
      expect(page).to have_text("Make notes and write questions to ask the regional delivery officer")
    end
  end

  context "when the checkbox has a title and hint" do
    let(:attribute) { "meeting" }

    it "renders the title and hint" do
      expect(page).to have_text(" Discuss any questions you have about the project in the meeting.")
      expect(page).to have_text("Discuss any questions you have about the project in the meeting.")
    end
  end

  context "when the checkbox has a title, hint and guidance" do
    let(:attribute) { "review" }

    it "renders the title, hint and guidance" do
      expect(page).to have_text("Review the project information, check the documents and carry out research")
      expect(page).to have_text("Check that no information is missing from the existing project documents and there are no errors.")
      expect(page).to have_text("Things to check during your background research include:")
    end
  end
end
