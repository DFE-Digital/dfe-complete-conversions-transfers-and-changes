require "rails_helper"

RSpec.describe TaskListPolicy do
  subject { described_class }
  before { mock_successful_api_response_to_create_any_project }

  let(:application_user) { create(:user, email: "application.user@education.gov.uk") }

  permissions :edit? do
    it "grants access if project is assigned to the same user" do
      expect(subject).to permit(application_user, create(:conversion_project, assigned_to: application_user).task_list)
    end

    it "grants access if project is assigned to a different user" do
      expect(subject).to permit(application_user, create(:conversion_project, assigned_to: create(:user)).task_list)
    end

    it "grants access if project is assigned to nil" do
      expect(subject).to permit(create(:user), create(:conversion_project, assigned_to: nil).task_list)
    end
  end

  permissions :update? do
    it "grants access if project is assigned to the same user" do
      expect(subject).to permit(application_user, create(:conversion_project, assigned_to: application_user).task_list)
    end

    it "denies access if project is assigned to a different user" do
      expect(subject).not_to permit(application_user, create(:conversion_project, assigned_to: create(:user)).task_list)
    end

    it "denies access if project is assigned to nil" do
      expect(subject).not_to permit(application_user, create(:conversion_project, assigned_to: nil).task_list)
    end
  end
end
