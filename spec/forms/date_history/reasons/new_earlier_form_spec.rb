require "rails_helper"

RSpec.describe DateHistory::Reasons::NewEarlierForm, type: :model do
  describe "attributes" do
    it "has the correct attributes" do
      form = described_class.new

      described_class::REASONS_LIST.each do |reason|
        expect(form).to respond_to(reason)
      end
    end
  end

  describe "validations" do
    it "validates that at least one reason must be checked" do
      form = described_class.new

      expect(form).to be_invalid
      expect(form.errors.messages_for(:base)).to include("You must choose at least one reason")
    end

    it "validates that any checked item has a note" do
      form = described_class.new(correcting_an_error: true, correcting_an_error_note: "")

      expect(form).to be_invalid
      expect(form.errors.messages_for(:correcting_an_error_note)).to include("You must provide details")
    end
  end

  describe "#save" do
    before do
      mock_all_academies_api_responses
      allow(SignificantDateCreatorService).to receive(:new).and_call_original
    end

    let(:project) { create(:conversion_project) }
    let(:user) { create(:user) }
    let(:revised_date) { Date.today.at_beginning_of_month - 1.month }

    it "calls the service when valid" do
      form = described_class.new(
        project: project,
        user: user,
        revised_date: revised_date,
        correcting_an_error: "1",
        correcting_an_error_note: "I made an error.",
        progressing_faster_than_expected: "1",
        progressing_faster_than_expected_note: "It is so fast."
      )
      form.save

      expect(SignificantDateCreatorService).to have_received(:new).with(
        project: project,
        user: user,
        revised_date: revised_date,
        reasons: [
          {type: :progressing_faster_than_expected, note_text: "It is so fast."},
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
        progressing_faster_than_expected: "0",
        progressing_faster_than_expected_note: "It is so fast."
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
end
