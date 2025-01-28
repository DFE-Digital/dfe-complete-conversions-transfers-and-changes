require "rails_helper"
migration_file = "db/migrate/20250127172701_backfill_missing_date_history_reason_notes.rb"
require Rails.root.join(migration_file)

RSpec.describe "Data migration to backfill SignificantDateHistoryReason notes" do
  let(:migration) { BackfillMissingDateHistoryReasonNotes.new }
  let(:problem_reason) { create(:date_history_reason) }

  before do
    mock_successful_api_response_to_create_any_project

    2.times { create(:date_history_reason) }
    problem_reason.note.delete
  end

  it "creates a note for the problem reason" do
    expect(SignificantDateHistoryReason.count).to eq(3)
    expect(Note.count).to eq(2)
    expect(problem_reason.reload.note).not_to be_present

    migration.up

    expect(SignificantDateHistoryReason.count).to eq(3)
    expect(Note.count).to eq(3)
    expect(problem_reason.reload.note).to be_present
  end

  context "when the note's user can't be found (e.g. in dev env)" do
    before do
      problem_reason.significant_date_history.user.delete
    end

    it "does NOT create the missing note" do
      expect(SignificantDateHistoryReason.count).to eq(3)
      expect(Note.count).to eq(2)
      expect(problem_reason.reload.note).not_to be_present

      migration.up

      expect(SignificantDateHistoryReason.count).to eq(3)
      expect(Note.count).to eq(2)
      expect(problem_reason.reload.note).not_to be_present
    end

    it "exits happily, i.e. the migration is done" do
      expect(migration.up).to be true
    end
  end
end
