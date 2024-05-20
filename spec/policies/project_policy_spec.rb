require "rails_helper"

RSpec.describe ProjectPolicy do
  subject { described_class }
  before { mock_successful_api_response_to_create_any_project }

  let(:application_user) { build(:user, :caseworker, email: "application.user@education.gov.uk") }
  let(:service_support_user) { build(:user, :service_support) }

  permissions :show? do
    it "grants access" do
      expect(subject).to permit(application_user, build(:conversion_project))
    end

    context "if the project is 'soft deleted'" do
      it "denies access" do
        expect(subject).to_not permit(application_user, build(:conversion_project, :deleted))
      end
    end
  end

  permissions :update? do
    it "grants access if project is assigned to the same user" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
    end

    it "grants access if the project is completed and the user is service support" do
      expect(subject).to permit(service_support_user, build(:conversion_project, completed_at: Date.yesterday, assigned_to: application_user, conversion_date_provisional: false))
    end

    it "grants access if the user is service support but assigned to a different user" do
      expect(subject).to permit(service_support_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
    end

    it "denies access if the project is assigned to another user" do
      expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: build(:user), conversion_date_provisional: false))
    end

    it "denies access if project is assigned to nil" do
      expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: nil, conversion_date_provisional: false))
    end

    it "denies access if the project is completed" do
      project = build(:conversion_project, :completed, assigned_to: application_user, conversion_date_provisional: false)
      expect(subject).not_to permit(application_user, project)
    end
  end

  permissions :edit?, :check?, :update_academy_urn? do
    it "grants access if project is assigned to the same user" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
    end

    it "grants access if the project is assigned to another user" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: build(:user), conversion_date_provisional: false))
    end

    it "grants access if project is assigned to nil" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: nil, conversion_date_provisional: false))
    end

    it "denies access if the project is completed" do
      project = build(:conversion_project, :completed, assigned_to: application_user, conversion_date_provisional: false)
      expect(subject).not_to permit(application_user, project)
    end

    it "denies access if the project is deleted" do
      project = build(:conversion_project, :deleted, assigned_to: application_user)
      expect(subject).not_to permit(application_user, project)
    end
  end

  permissions :change_conversion_date? do
    context "when the conversion date is not provisional" do
      it "grants access if project is assigned to the same user" do
        expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
      end

      it "grants access if the user is service support" do
        expect(subject).to permit(build(:user, :service_support), build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
      end

      it "grants access if the project is complete and the user is service support" do
        expect(subject).to permit(build(:user, :service_support), build(:conversion_project, completed_at: Date.yesterday, assigned_to: application_user, conversion_date_provisional: false))
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
      project = build(:conversion_project, assigned_to: application_user)
      expect(subject).to permit(application_user, project)
    end

    it "denies access if project is completed" do
      project = build(:conversion_project, :completed, assigned_to: application_user)
      expect(subject).not_to permit(application_user, project)
    end

    it "denies access if the user has no role" do
      user = build(:user)
      project = build(:conversion_project)

      expect(subject).not_to permit(user, project)
    end
  end

  permissions :update_assigned_to? do
    it "grants access if project is not completed" do
      project = build(:conversion_project, assigned_to: application_user)
      expect(subject).to permit(application_user, project)
    end

    it "denies access if project is completed" do
      project = build(:conversion_project, :completed, assigned_to: application_user)
      expect(subject).not_to permit(application_user, project)
    end
  end

  permissions :update_regional_delivery_officer? do
    it "grants access if project is not completed" do
      project = build(:conversion_project, assigned_to: application_user)
      expect(subject).to permit(application_user, project)
    end

    it "denies access if project is completed" do
      project = build(:conversion_project, :completed, assigned_to: application_user)
      expect(subject).not_to permit(application_user, project)
    end
  end

  permissions :unassigned? do
    it "denies access to anyone who is not a team leader" do
      expect(subject).to permit(build(:user, :team_leader))
      expect(subject).to_not permit(application_user)
    end
  end

  permissions :handed_over? do
    it "denies access to anyone who is in the regional casework services team" do
      expect(subject).to_not permit(build(:user, team: "regional_casework_services"))
      expect(subject).to permit(build(:user, :regional_delivery_officer))
    end
  end

  permissions :new_mat?, :create_mat? do
    it "grants access if the user can add a new project" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user))
    end
  end
end
