require "rails_helper"

RSpec.describe Note, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:body).of_type :text }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:conversion_project) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:task).required(false) }
  end

  describe "Validations" do
    describe "#body" do
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to_not allow_values("", nil).for(:body) }
    end
  end

  describe "Scopes" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    describe "default_scope" do
      before do
        freeze_time
        travel_to(Date.yesterday) { create(:note, body: "Yesterday's note.") }
        create(:note, body: "Today's note.")
      end

      it "orders descending by the 'created_at' attribute" do
        expect(Note.first.body).to eq "Today's note."
      end
    end

    describe "project_level_notes" do
      let!(:project_level_note) { create(:note) }
      let!(:task_level_note) { create(:note, :task_level_note) }

      subject { Note.project_level_notes(project_level_note.conversion_project) }

      it "returns only project level notes" do
        expect(subject).to include project_level_note
        expect(subject).not_to include task_level_note
      end
    end
  end

  describe "#task_level_note?" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    subject { note.task_level_note? }

    context "when the Note is not associated with a Task" do
      let(:note) { create(:note) }

      it { expect(subject).to be false }
    end

    context "when the Note is associated with a Task" do
      let(:note) { create(:note, :task_level_note) }

      it { expect(subject).to be true }
    end
  end
end
