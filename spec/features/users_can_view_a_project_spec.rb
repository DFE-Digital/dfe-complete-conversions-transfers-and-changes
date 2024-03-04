require "rails_helper"

RSpec.feature "Users can view a project" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "they can view a summary of the project details" do
    visit project_path(project)

    within(".govuk-caption-l .govuk-tag--purple") do
      expect(page).to have_content("Conversion")
    end

    within("#project-summary") do
      expect(page).to have_content(project.incoming_trust.name)
      expect(page).to have_content(project.conversion_date.to_formatted_s(:govuk))
      expect(page).to have_content(project.establishment.local_authority_name)
      expect(page).to have_content(project.incoming_trust.name)
      expect(page).to have_content(project.establishment.region_name)
      expect(page).to have_link(I18n.t("project.summary.school_sharepoint_link.title"), href: project.establishment_sharepoint_link)
      expect(page).to have_link(I18n.t("project.summary.trust_sharepoint_link.title"), href: project.incoming_trust_sharepoint_link)
    end
  end

  context "when the project is a Form a MAT conversion" do
    let(:project) { create(:conversion_project, :form_a_mat, caseworker: user) }

    scenario "they can see a Form a MAT label" do
      visit project_path(project)

      within(".govuk-caption-l .govuk-tag--pink") do
        expect(page).to have_content("Form a MAT")
      end
    end
  end
end
