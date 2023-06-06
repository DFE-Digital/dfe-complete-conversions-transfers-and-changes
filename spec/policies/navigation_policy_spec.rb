require "rails_helper"

RSpec.describe NavigationPolicy do
  permissions :show_header_navigation? do
    it "does not permit a user that has no role" do
      user = build(:user)
      expect(described_class).not_to permit(user)
    end

    it "permits for a user that has the caseworker role" do
      user = build(:user, :caseworker)
      expect(described_class).to permit(user)
    end

    it "permits for a user that has the regional delivery officer role" do
      user = build(:user, :regional_delivery_officer)
      expect(described_class).to permit(user)
    end

    it "permits for a user that has the regional casework services team lead role" do
      user = build(:user, :team_leader)
      expect(described_class).to permit(user)
    end

    it "permits for a user that has the service support role" do
      user = build(:user, :service_support)
      expect(described_class).to permit(user)
    end
  end

  permissions :show_your_projects_header_navigation? do
    it "does not permit a user that has no role" do
      user = build(:user)
      expect(described_class).not_to permit(user)
    end

    it "permits for a user that has the caseworker role" do
      user = build(:user, :caseworker)
      expect(described_class).to permit(user)
    end

    it "permits for a user that has the regional delivery officer role" do
      user = build(:user, :regional_delivery_officer)
      expect(described_class).to permit(user)
    end

    it "does not permit for a user that has the regional casework services team lead role" do
      user = build(:user, :team_leader)
      expect(described_class).not_to permit(user)
    end

    it "does not permit for a user that has the service support role" do
      user = build(:user, :service_support)
      expect(described_class).not_to permit(user)
    end
  end

  permissions :show_team_projects_header_navigation? do
    it "does not permit a user that has no role" do
      user = build(:user)
      expect(described_class).not_to permit(user)
    end

    it "does not permit for a user that has the caseworker role" do
      user = build(:user, :caseworker)
      expect(described_class).not_to permit(user)
    end

    it "does not permit for a user that has the regional delivery officer role" do
      user = build(:user, :regional_delivery_officer)
      expect(described_class).not_to permit(user)
    end

    it "permits for a user that has the regional casework services team lead role" do
      user = build(:user, :team_leader)
      expect(described_class).to permit(user)
    end

    it "does not permit for a user that has the service support role" do
      user = build(:user, :service_support)
      expect(described_class).not_to permit(user)
    end
  end

  permissions :show_all_projects_header_navigation? do
    it "does not permit a user that has no role" do
      user = build(:user)
      expect(described_class).not_to permit(user)
    end

    it "permits for a user that has the caseworker role" do
      user = build(:user, :caseworker)
      expect(described_class).to permit(user)
    end

    it "permits for a user that has the regional delivery officer role" do
      user = build(:user, :regional_delivery_officer)
      expect(described_class).to permit(user)
    end

    it "permits for a user that has the regional casework services team lead role" do
      user = build(:user, :team_leader)
      expect(described_class).to permit(user)
    end

    it "permits for a user that has the service support role" do
      user = build(:user, :service_support)
      expect(described_class).to permit(user)
    end
  end

  permissions :show_service_support_header_navigation? do
    it "does not permit a user that has no role" do
      user = build(:user)
      expect(described_class).not_to permit(user)
    end

    it "does not permit for a user that has the caseworker role" do
      user = build(:user, :caseworker)
      expect(described_class).not_to permit(user)
    end

    it "does not permit for a user that has the regional delivery officer role" do
      user = build(:user, :regional_delivery_officer)
      expect(described_class).not_to permit(user)
    end

    it "does not permit for a user that has the regional casework services team lead role" do
      user = build(:user, :team_leader)
      expect(described_class).not_to permit(user)
    end

    it "permits for a user that has the service support role" do
      user = build(:user, :service_support)
      expect(described_class).to permit(user)
    end
  end
end
