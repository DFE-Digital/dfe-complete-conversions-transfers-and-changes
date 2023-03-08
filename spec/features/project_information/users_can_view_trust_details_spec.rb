require "rails_helper"

RSpec.feature "Users can view school details" do
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
end
