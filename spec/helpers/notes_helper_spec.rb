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
end
