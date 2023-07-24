require "rails_helper"

RSpec.describe ConversionDateUpdater do
  let(:user) { create(:user, :caseworker) }
  let(:note_body) { "This is my note body." }

  before do
    mock_successful_api_calls(establishment: any_args, trust: any_args)
  end

  describe "#update!" do
    it "returns true when successful" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      conversion_date_updater = described_class.new(project: project, revised_date: revised_date, note_body: note_body, user: user)

      expect(conversion_date_updater.update!).to be true
    end

    it "creates the conversion date history and note" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      conversion_date_updater = described_class.new(project: project, revised_date: revised_date, note_body: note_body, user: user)

      expect(conversion_date_updater.update!).to be true
      expect(project.significant_dates.count).to eql 1
      expect(Note.count).to eql 1

      conversion_date_history = project.significant_dates.first
      expect(conversion_date_history.revised_date).to eql revised_date

      note = conversion_date_history.note
      expect(note.user).to eql user
      expect(note.project).to eql project
      expect(note.body).to eql note_body
    end

    it "updates the project conversion date with the revised date" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      conversion_date_updater = described_class.new(project: project, revised_date: revised_date, note_body: note_body, user: user)

      expect(conversion_date_updater.update!).to be true

      expect(project.reload.conversion_date).to eql revised_date
    end

    it "is transactional, it does nothing if any operation fails and returns false" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      revised_date = project.conversion_date + 2.months

      allow(project).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)

      conversion_date_updater = ConversionDateUpdater.new(project: project, revised_date: revised_date, note_body: note_body, user: user)

      expect(conversion_date_updater.update!).to be false
      expect(project.reload.conversion_date).not_to eql revised_date
      expect(Note.count).to be_zero
      expect(project.significant_dates.count).to be_zero
    end
  end
end
