require "rails_helper"

RSpec.describe ExportPolicy do
  let(:data_consumers_user) { build(:user, team: :data_consumers) }
  let(:rdo_user) { build(:regional_delivery_officer_user) }
  let(:rcs_user) { build(:regional_casework_services_user) }
  let(:rcs_team_lead_user) { build(:regional_casework_services_user, :team_leader) }
  let(:service_support_user) { build(:service_support_user) }
  let(:business_support_user) { build(:user, team: :business_support) }

  permissions :index?, :show?, :new?, :create?, :csv? do
    it "grants access if the user is in one of the correct teams" do
      expect(described_class).to permit(business_support_user)
      expect(described_class).to permit(service_support_user)
      expect(described_class).to permit(data_consumers_user)
      expect(described_class).not_to permit(rdo_user)
      expect(described_class).not_to permit(rcs_user)
      expect(described_class).to permit(rcs_team_lead_user)
    end
  end
end
