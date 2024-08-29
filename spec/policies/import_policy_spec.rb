require "rails_helper"

RSpec.describe ImportPolicy do
  let(:data_consumer_user) { build(:user, team: :data_consumers) }
  let(:rdo_user) { build(:regional_delivery_officer_user) }
  let(:rcs_user) { build(:regional_casework_services_user) }
  let(:service_support_user) { build(:service_support_user) }

  permissions :new?, :upload? do
    it "grants access if the user is in the service support team" do
      expect(described_class).not_to permit(data_consumer_user)
      expect(described_class).not_to permit(rdo_user)
      expect(described_class).not_to permit(rcs_user)
      expect(described_class).to permit(service_support_user)
    end
  end
end
