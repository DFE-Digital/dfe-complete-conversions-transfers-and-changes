require "rails_helper"

RSpec.describe AssignmentPolicy do
  subject { described_class }

  permissions :edit_added_by_user?, :update_added_by_user? do
    it "grants access when the user is a team lead" do
      user = build(:user, :team_leader)
      expect(subject).to permit(user)
    end

    it "grants access when the user is service support" do
      user = build(:user, :service_support)
      expect(subject).to permit(user)
    end

    it "denies access when the user is not a team lead" do
      user = build(:user)
      expect(subject).not_to permit(user)
    end
  end

  permissions :edit_assigned_user?, :update_assigned_user? do
    it "grants access when the user is a team lead" do
      user = build(:user, :caseworker)
      expect(subject).to permit(user)
    end

    it "grants access when the user is service support" do
      user = build(:user, :service_support)
      expect(subject).to permit(user)
    end

    it "denies access when the user is not a team lead" do
      user = build(:user)
      expect(subject).not_to permit(user)
    end
  end
end
