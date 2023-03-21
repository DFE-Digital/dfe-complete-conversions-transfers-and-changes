require "rails_helper"

RSpec.describe ContactPolicy do
  subject { described_class }
  before { mock_successful_api_response_to_create_any_project }

  let(:application_user) { build(:user, email: "application.user@education.gov.uk") }

  permissions :edit?, :update?, :destroy?, :confirm_destroy? do
    it "grants access if project is not completed" do
      project = build(:conversion_project, assigned_to: application_user, completed_at: nil)
      expect(subject).to permit(application_user, build(:contact, project: project))
    end

    it "denies access if project is completed" do
      project = build(:conversion_project, assigned_to: application_user, completed_at: Date.yesterday)
      expect(subject).not_to permit(application_user, build(:contact, project: project))
    end
  end
end
