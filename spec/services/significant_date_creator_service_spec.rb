require "rails_helper"

RSpec.describe SignificantDateCreatorService do
  let(:user) { create(:user, :caseworker) }
  let(:reasons) { [{type: :legacy_reason, note_text: "This is my note body."}] }

  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "#update!" do
    it "returns true when successful" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      conversion_date_updater = described_class.new(project: project, revised_date: revised_date, user: user, reasons: reasons)

      expect(conversion_date_updater.update!).to be true
    end

    it "creates the conversion date history, reason and note" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      conversion_date_updater = described_class.new(project: project, revised_date: revised_date, user: user, reasons: reasons)

      expect(conversion_date_updater.update!).to be true

      expect(project.significant_dates.count).to eql 1
      expect(project.significant_dates.first.reasons.count).to eql 1
      expect(Note.count).to eql 1

      conversion_date_history = project.significant_dates.first
      expect(conversion_date_history.revised_date).to eql revised_date
      expect(conversion_date_history.user).to eql user

      first_reason = conversion_date_history.reasons.first
      expect(first_reason.reason_type).to eql "legacy_reason"

      note = first_reason.note
      expect(note.user).to eql user
      expect(note.project).to eql project
      expect(note.body).to eql "This is my note body."
    end

    it "updates the project conversion date with the revised date" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      conversion_date_updater = described_class.new(project: project, revised_date: revised_date, user: user, reasons: reasons)

      expect(conversion_date_updater.update!).to be true

      expect(project.reload.conversion_date).to eql revised_date
    end

    it "is transactional, it does nothing if any operation fails and returns false" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      allow(project).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)

      conversion_date_updater = described_class.new(project: project, revised_date: revised_date, user: user, reasons: reasons)

      expect(conversion_date_updater.update!).to be false
      expect(project.reload.conversion_date).not_to eql revised_date
      expect(Note.count).to be_zero
      expect(project.significant_dates.count).to be_zero
    end

    it "raises an error when reasons is nil" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      expect {
        described_class.new(project: project, revised_date: revised_date, user: user, reasons: nil)
      }.to raise_error(ArgumentError)
    end

    it "raises an error when reasons is empty" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      expect {
        described_class.new(project: project, revised_date: revised_date, user: user, reasons: [])
      }.to raise_error(ArgumentError)
    end

    it "raises an error when there is an invalid reason key" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months
      invalid_reason = {invalid_key: :reason_type, note_text: "This is not valid"}

      expect {
        described_class.new(project: project, revised_date: revised_date, user: user, reasons: [invalid_reason]).update!
      }.to raise_error(ArgumentError)
    end

    it "returns false with a invalid reason type because the reason will not be saved" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months
      invalid_reason = {type: "", note_text: "This is not valid"}

      result = described_class.new(project: project, revised_date: revised_date, user: user, reasons: [invalid_reason]).update!

      expect(result).to be false
    end
  end
end
