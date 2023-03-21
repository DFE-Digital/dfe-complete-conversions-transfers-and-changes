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
        project = build(:conversion_project, assigned_to: application_user, completed_at: Date.yesterday)
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
end
