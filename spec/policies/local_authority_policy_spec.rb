require "rails_helper"

RSpec.describe LocalAuthorityPolicy do
  subject { described_class }

  context "when the user is a service_support user" do
    let(:user) { create(:user, :service_support) }

    permissions :new?, :create?, :edit?, :update?, :destroy?, :confirm_destroy? do
      it "permits the action" do
        expect(subject).to permit(user, build(:local_authority))
      end
    end
  end

  context "when the user is any other user role" do
    [:caseworker, :team_leader, :regional_delivery_officer].each do |role|
      let(:user) { create(:user, role) }

      permissions :new?, :create?, :edit?, :update?, :destroy?, :confirm_destroy? do
        it "denies the action to the #{role}" do
          expect(subject).not_to permit(user, build(:local_authority))
        end
      end
    end
  end
end
