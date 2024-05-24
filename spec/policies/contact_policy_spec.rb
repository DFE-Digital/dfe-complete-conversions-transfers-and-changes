require "rails_helper"

RSpec.describe ContactPolicy do
  subject { described_class }
  before { mock_successful_api_response_to_create_any_project }

  let(:application_user) { build(:user, :caseworker, email: "application.user@education.gov.uk") }

  permissions :edit?, :update?, :destroy?, :confirm_destroy? do
    it "grants access if project is not completed" do
      project = build(:conversion_project, assigned_to: application_user)
      expect(subject).to permit(application_user, build(:project_contact, project: project))
    end

    it "grants access if the user is in the service support team" do
      application_user = build(:user, :service_support)
      project = build(:conversion_project, assigned_to: application_user)
      expect(subject).to permit(application_user, build(:project_contact, project: project))
    end

    it "denies if the user has no role" do
      user = build(:user)
      project = build(:conversion_project)

      expect(subject).not_to permit(user, build(:project_contact, project: project))
    end

    it "denies access if project is completed" do
      project = build(:conversion_project, :completed, assigned_to: application_user)
      expect(subject).not_to permit(application_user, build(:project_contact, project: project))
    end
  end
end
