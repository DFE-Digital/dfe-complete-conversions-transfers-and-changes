require "rails_helper"

RSpec.feature "Users can view trust details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  scenario "they can view the trust name, UKPRN and companies house number" do
    within("#trustDetails") do
      expect(page).to have_content(project.incoming_trust.name)
      expect(page).to have_content(project.incoming_trust_ukprn)
      expect(page).to have_content(project.incoming_trust.companies_house_number)
    end
  end

  scenario "the trust address is shown" do
    within("#trustDetails") do
      expect(page).to have_content(project.incoming_trust.address_street)
      expect(page).to have_content(project.incoming_trust.address_additional)
      expect(page).to have_content(project.incoming_trust.address_locality)
      expect(page).to have_content(project.incoming_trust.address_town)
      expect(page).to have_content(project.incoming_trust.address_county)
      expect(page).to have_content(project.incoming_trust.address_postcode)
    end
  end
end
