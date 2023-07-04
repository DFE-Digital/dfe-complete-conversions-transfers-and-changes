require "rails_helper"

RSpec.describe UserPolicy do
  permissions :index?, :new?, :create?, :edit?, :update? do
    it "grants access if the user has the service_support flag" do
      user = build(:user, :service_support)
      expect(described_class).to permit(user)
    end

    it "denies access if the user does not have service_support flag" do
      user = build(:user, service_support: false)
      expect(described_class).not_to permit(user)
    end
  end
end
