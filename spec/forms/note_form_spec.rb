require "rails_helper"

RSpec.describe NoteForm, type: :model do
  let(:note_form_instance) { described_class.new }

  describe "Validations" do
    describe "#body" do
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to_not allow_values("", nil).for(:body) }
    end
  end

  describe "#create" do
    let(:project) { create(:project) }
    let(:user) { create(:user) }

    subject { note_form_instance.create }

    context "when the underlying ActiveRecord model has a validaiton error" do
      before { note_form_instance.assign_attributes(body: "Some body") }

      it "raises the ActiveRecord error" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when valid" do
      before { note_form_instance.assign_attributes(project:, body: "Some body", user_id: user.id) }

      it "creates a project" do
        subject

        expect(Note.count).to be 1
      end
    end
  end
end
