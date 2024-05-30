require "rails_helper"

RSpec.describe ExportPolicy do
  let(:esfa_user) { build(:user, team: :education_and_skills_funding_agency) }
  let(:aopu_user) { build(:user, team: :academies_operational_practice_unit) }
  let(:rdo_user) { build(:regional_delivery_officer_user) }
  let(:rcs_user) { build(:regional_casework_services_user) }
  let(:service_support_user) { build(:service_support_user) }
  let(:business_support_user) { build(:user, team: :business_support) }

  permissions :index?, :show?, :new?, :create?, :csv? do
    it "grants access if the user is in one of the correct teams" do
      expect(described_class).to permit(esfa_user)
      expect(described_class).to permit(aopu_user)
      expect(described_class).to permit(business_support_user)
      expect(described_class).to permit(service_support_user)
      expect(described_class).not_to permit(rdo_user)
      expect(described_class).not_to permit(rcs_user)
    end
  end

  permissions :service_support? do
    it "grants access if the user is a service support user" do
      expect(described_class).to permit(service_support_user)
      expect(described_class).not_to permit(esfa_user)
      expect(described_class).not_to permit(aopu_user)
      expect(described_class).not_to permit(business_support_user)
      expect(described_class).not_to permit(rdo_user)
      expect(described_class).not_to permit(rcs_user)
    end
  end
end
