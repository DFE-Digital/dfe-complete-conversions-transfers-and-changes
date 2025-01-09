require "rails_helper"

RSpec.feature "Users can view school details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user, urn: 888888) }

  before do
    mock_successful_api_responses(urn: 888888, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  scenario "they can view the school details" do
    within("#schoolDetails") do
      expect(page).to have_content(project.establishment.name)
      expect(page).to have_content(888888)
      expect(page).to have_content(project.establishment.type)
      expect(page).to have_content(project.establishment.phase)
    end
  end

  scenario "the school address is shown" do
    within("#schoolDetails") do
      expect(page).to have_content(project.establishment.address_street)
      expect(page).to have_content(project.establishment.address_additional)
      expect(page).to have_content(project.establishment.address_locality)
      expect(page).to have_content(project.establishment.address_town)
      expect(page).to have_content(project.establishment.address_county)
      expect(page).to have_content(project.establishment.address_postcode)
    end
  end
end
