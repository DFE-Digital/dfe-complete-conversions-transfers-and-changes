require "rails_helper"

RSpec.describe NotePolicy do
  subject { described_class }
  before { mock_successful_api_response_to_create_any_project }

  let(:application_user) { build(:user, email: "application.user@education.gov.uk") }

  permissions :edit?, :update?, :destroy? do
    context "when the note was created by the user" do
      it "grants access if project is not completed" do
        project = build(:conversion_project, assigned_to: application_user, completed_at: nil)
        expect(subject).to permit(application_user, build(:note, project: project, user: application_user))
      end

      it "denies access if project is completed" do
        project = build(:conversion_project, :completed, assigned_to: application_user)
        expect(subject).not_to permit(application_user, build(:note, project: project, user: application_user))
      end
    end

    context "when the note was not created by the user" do
      it "denies access if project is completed" do
        project = build(:conversion_project, assigned_to: application_user, completed_at: Date.yesterday)
        expect(subject).not_to permit(application_user, build(:note, project: project))
      end

      it "denies access if project is not completed" do
        project = build(:conversion_project, assigned_to: application_user, completed_at: nil)
        expect(subject).not_to permit(application_user, build(:note, project: project))
      end
    end
  end

  context "when the note is from a conversion date history" do
    permissions :edit?, :update? do
      it "allows if the note is from a date history" do
        note = build(:note, :for_significant_date_history_reason, user: application_user)
        allow(note).to receive(:notable_id).and_return("uuid")

        expect(subject).to permit(application_user, note)
      end
    end

    permissions :destroy? do
      it "denies all actions if the note is from a date history" do
        note = build(:note, :for_significant_date_history_reason, user: application_user)
        allow(note).to receive(:notable_id).and_return("uuid")

        expect(subject).not_to permit(application_user, note)
      end
    end
  end
end
