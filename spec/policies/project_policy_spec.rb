require "rails_helper"

RSpec.describe ProjectPolicy do
  subject { described_class }
  before { mock_successful_api_response_to_create_any_project }

  let(:application_user) { build(:user, email: "application.user@education.gov.uk") }

  permissions :update? do
    it "grants access if project is assigned to the same user" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
    end

    it "denies access if the project is assigned to another user" do
      expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: build(:user), conversion_date_provisional: false))
    end

    it "denies access if project is assigned to nil" do
      expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: nil, conversion_date_provisional: false))
    end

    it "denies access if the project is completed" do
      project = build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false, completed_at: Date.yesterday)
      expect(subject).not_to permit(application_user, project)
    end
  end

  permissions :change_conversion_date? do
    context "when the conversion date is not provisional" do
      it "grants access if project is assigned to the same user" do
        expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
      end

      it "denies access if the project is assigned to another user" do
        expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: build(:user), conversion_date_provisional: false))
      end

      it "denies access if project is assigned to nil" do
        expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: nil, conversion_date_provisional: false))
      end
    end

    context "when the conversion date is provisional" do
      it "denies access if project is assigned to the same user" do
        expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: true))
      end

      it "denies access if the project is assigned to another user" do
        expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: build(:user), conversion_date_provisional: true))
      end

      it "denies access if project is assigned to nil" do
        expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: nil, conversion_date_provisional: true))
      end
    end
  end

  permissions :new_note?, :new_contact? do
    it "grants access if project is not completed" do
      project = build(:conversion_project, assigned_to: application_user, completed_at: nil)
      expect(subject).to permit(application_user, project)
    end

    it "denies access if project is completed" do
      project = build(:conversion_project, assigned_to: application_user, completed_at: Date.yesterday)
      expect(subject).not_to permit(application_user, project)
    end
  end
end
