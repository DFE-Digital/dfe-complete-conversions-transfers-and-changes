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

  permissions :update?, :edit?, :check?, :update_academy_urn?, :dao_revocation? do
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

    it "denies access if the project is deleted" do
      project = build(:conversion_project, :deleted, assigned_to: application_user)
      expect(subject).not_to permit(application_user, project)
    end

    context "when the user is service support" do
      it "grants access if the project is completed" do
        project = build(:conversion_project, :completed)
        expect(subject).to permit(service_support_user, project)
      end

      it "grants access if the project is dao revoked" do
        project = build(:conversion_project, state: :dao_revoked)
        expect(subject).to permit(service_support_user, project)
      end

      it "denies access if the project is deleted" do
        project = build(:conversion_project, :deleted)
        expect(subject).not_to permit(service_support_user, project)
      end
    end
  end

  permissions :change_significant_date? do
    it "grants access when the significant date is not provisional" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
    end
    it "denies access when the significant date is provisional" do
      expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: true))
    end
  end

  permissions :change_conversion_date? do
    it "grants access when the project is a conversion" do
      expect(subject).to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
    end

    it "denies access when the project is a transfer" do
      expect(subject).not_to permit(application_user, build(:transfer_project, assigned_to: application_user, transfer_date_provisional: false))
    end
  end

  permissions :change_transfer_date? do
    it "grants access when the project is a transfer" do
      expect(subject).to permit(application_user, build(:transfer_project, assigned_to: application_user, transfer_date_provisional: false))
    end

    it "denies access when the project is a conversion" do
      expect(subject).not_to permit(application_user, build(:conversion_project, assigned_to: application_user, conversion_date_provisional: false))
    end
  end

  permissions :new_note?, :new_contact? do
    it "grants access if project is active" do
      project = build(:conversion_project, state: :active, assigned_to: application_user)
      expect(subject).to permit(application_user, project)
    end

    it "denies access if project is completed" do
      project = build(:conversion_project, :completed, assigned_to: application_user)
      expect(subject).not_to permit(application_user, project)
    end

    it "denies access if project has been dao revoked" do
      project = build(:conversion_project, state: :dao_revoked, assigned_to: application_user)
      expect(subject).not_to permit(application_user, project)
    end

    it "denies access if project is deleted" do
      project = build(:conversion_project, state: :deleted, assigned_to: application_user)
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

  permissions :new?, :create?, :new_mat?, :create_mat? do
    it "grants access if the user can add a new project" do
      expect(subject).to permit(application_user)
    end

    it "denies access if the user cannot add projects" do
      expect(subject).not_to permit(create(:user))
    end
  end

  permissions :handover? do
    it "grants access if the user is a regional delivery officer" do
      expect(subject).to permit(build(:regional_delivery_officer_user))
    end

    it "grants access if the user is a service support user" do
      expect(subject).to permit(build(:regional_delivery_officer_user))
    end

    it "denies access if the user is not a regional delivery officer or service support user" do
      expect(subject).not_to permit(build(:regional_casework_services_user))
      expect(subject).not_to permit(build(:inactive_user))
    end
  end
end
