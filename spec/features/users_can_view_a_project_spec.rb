require "rails_helper"

RSpec.feature "Users can view a project" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "they can view a summary of the project details" do
    visit conversion_project_path(project)

    within("#project-summary") do
      expect(page).to have_content(project.incoming_trust.name)
      expect(page).to have_content(project.provisional_conversion_date.to_formatted_s(:govuk))
      expect(page).to have_content(project.establishment.local_authority)
      expect(page).to have_content(project.incoming_trust.name)
      expect(page).to have_content(project.establishment.region_name)
      expect(page).to have_link(I18n.t("project.summary.establishment_sharepoint_link.value"), href: project.establishment_sharepoint_link)
      expect(page).to have_link(I18n.t("project.summary.trust_sharepoint_link.value"), href: project.trust_sharepoint_link)
    end
  end
end
