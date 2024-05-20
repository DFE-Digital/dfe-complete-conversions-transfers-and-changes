require "rails_helper"

RSpec.describe TaskListPolicy do
  subject { described_class }
  before { mock_successful_api_response_to_create_any_project }

  let(:application_user) { build(:user, email: "application.user@education.gov.uk") }
  let(:service_support_user) { build(:user, :service_support) }

  permissions :edit? do
    it "grants access if project is assigned to the same user" do
      task_list = build(:conversion_project, assigned_to: application_user).tasks_data
      expect(subject).to permit(application_user, task_list)
    end

    it "grants access if project is assigned to a different user" do
      task_list = build(:conversion_project, assigned_to: build(:user)).tasks_data
      expect(subject).to permit(application_user, task_list)
    end

    it "grants access if project is assigned to nil" do
      task_list = build(:conversion_project, assigned_to: nil).tasks_data
      expect(subject).to permit(create(:user), task_list)
    end
  end

  permissions :update? do
    context "when the project is in progress" do
      it "grants access if project is assigned to the same user" do
        task_list = create(:conversion_project, assigned_to: application_user).tasks_data
        expect(subject).to permit(application_user, task_list)
      end

      it "grants access if the project is completed and the user is service support" do
        task_list = create(:conversion_project, completed_at: Date.yesterday, assigned_to: application_user).tasks_data
        expect(subject).to permit(service_support_user, task_list)
      end

      it "grants access if the user is service support and the project is assigned to a different user" do
        task_list = create(:conversion_project, assigned_to: application_user).tasks_data
        expect(subject).to permit(service_support_user, task_list)
      end

      it "denies access if project is assigned to a different user" do
        task_list = create(:conversion_project, assigned_to: build(:user)).tasks_data
        expect(subject).not_to permit(application_user, task_list)
      end

      it "denies access if project is assigned to nil" do
        task_list = create(:conversion_project, assigned_to: nil).tasks_data
        expect(subject).not_to permit(application_user, task_list)
      end
    end

    context "when the project is completed" do
      it "denies access if project is assigned to the same user" do
        task_list = create(:conversion_project, :completed, assigned_to: application_user).tasks_data
        expect(subject).not_to permit(application_user, task_list)
      end

      it "denies access if project is assigned to a different user" do
        task_list = create(:conversion_project, :completed, assigned_to: build(:user)).tasks_data
        expect(subject).not_to permit(application_user, task_list)
      end

      it "denies access if project is assigned to nil" do
        task_list = create(:conversion_project, :completed, assigned_to: nil).tasks_data
        expect(subject).not_to permit(application_user, task_list)
      end
    end
  end
end
