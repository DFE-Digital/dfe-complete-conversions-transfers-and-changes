require "rails_helper"

RSpec.describe DateHistory::Reasons::NewLaterForm, type: :model do
  before do
    mock_all_academies_api_responses
    allow(SignificantDateCreatorService).to receive(:new).and_call_original
  end

  let(:project) { create(:conversion_project) }
  let(:user) { create(:user) }
  let(:revised_date) { Date.today.at_beginning_of_month - 1.month }

  describe "attributes" do
    it "has the correct attributes" do
      form = described_class.new

      described_class::ALL_REASONS_LIST.each do |reason|
        expect(form).to respond_to(reason)
      end
    end
  end

  describe "validations" do
    it "validates that at least one reason must be checked" do
      form = described_class.new(project: project, user: user)

      expect(form).to be_invalid
      expect(form.errors.messages_for(:base)).to include("You must choose at least one reason")
    end

    it "validates that any checked item has a note" do
      form = described_class.new(project: project, user: user, correcting_an_error: true, correcting_an_error_note: "")

      expect(form).to be_invalid
      expect(form.errors.messages_for(:correcting_an_error_note)).to include("You must provide details")
    end
  end

  describe "#save" do
    it "calls the service when valid" do
      form = described_class.new(
        project: project,
        user: user,
        revised_date: revised_date,
        correcting_an_error: "1",
        correcting_an_error_note: "I made an error.",
        school: "1",
        school_note: "Requested a new date."
      )
      form.save

      expect(SignificantDateCreatorService).to have_received(:new).with(
        project: project,
        user: user,
        revised_date: revised_date,
        reasons: [
          {type: :school, note_text: "Requested a new date."},
          {type: :correcting_an_error, note_text: "I made an error."}
        ]
      ).exactly(1).time
    end

    it "only sends the selected reasons" do
      form = described_class.new(
        project: project,
        user: user,
        revised_date: revised_date,
        correcting_an_error: "1",
        correcting_an_error_note: "I made an error.",
        school: "0",
        school_note: "Requested a new date."
      )
      form.save

      expect(SignificantDateCreatorService).to have_received(:new).with(
        project: project,
        user: user,
        revised_date: revised_date,
        reasons: [
          {type: :correcting_an_error, note_text: "I made an error."}
        ]
      ).exactly(1).time
    end

    it "returns false when trying to save an invalid form" do
      form = described_class.new
      allow(form).to receive(:valid?).and_return(false)

      expect(form.save).to be false
    end
  end

  describe "#reasons_list" do
    it "returns the correct list when the project is a conversion" do
      project = create(:conversion_project)
      form = described_class.new(project: project, user: user)

      expect(form.reasons_list).to eql described_class::CONVERSION_REASONS_LIST
    end

    it "returns the correct list when the project is a transfer" do
      project = create(:transfer_project)
      form = described_class.new(project: project, user: user)

      expect(form.reasons_list).to eql described_class::TRANSFER_REASONS_LIST
    end

    it "raises an error when the project is nil" do
      form = described_class.new(project: nil, user: user)

      expect { form.reasons_list }.to raise_error("Unknown project type or nil project.")
    end
  end
end
