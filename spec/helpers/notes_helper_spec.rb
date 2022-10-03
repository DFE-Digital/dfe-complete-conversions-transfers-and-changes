require "rails_helper"

RSpec.describe NotesHelper, type: :helper do
  describe "#has_notes?" do
    context "when notes is nil" do
      let(:notes) { nil }

      it "returns false" do
        expect(helper.has_notes?(notes)).to be false
      end
    end

    context "when notes is an empty array" do
      let(:notes) { [] }

      it "returns false" do
        expect(helper.has_notes?(notes)).to be false
      end
    end

    context "when there are notes" do
      let(:notes) { [build(:note)] }

      it "returns true" do
        expect(helper.has_notes?(notes)).to be true
      end
    end
  end

  describe "#back_link_destination" do
    before { mock_successful_api_responses(urn: 123456, ukprn: 10061021) }

    subject { helper.back_link_destination(note) }

    context "when the note is a project level note" do
      let(:note) { create(:note) }

      it { expect(subject).to eq project_notes_path(note.project) }
    end

    context "when the note is a task level note" do
      let(:note) { create(:note, :task_level_note) }

      it { expect(subject).to eq project_task_path(note.project, note.task) }
    end
  end
end
