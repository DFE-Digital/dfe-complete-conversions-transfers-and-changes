require "rails_helper"

RSpec.describe UserPolicy do
  permissions :index?, :new?, :create?, :edit?, :update? do
    it "grants access if the user has the manage_user_accounts flag" do
      user = build(:user, manage_user_accounts: true)
      expect(described_class).to permit(user)
    end

    it "denies access if the user does not have manage_user_accounts flag" do
      user = build(:user, manage_user_accounts: false)
      expect(described_class).not_to permit(user)
    end
  end
end
