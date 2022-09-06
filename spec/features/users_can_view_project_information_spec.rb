require "rails_helper"

RSpec.feature "Users can view project information" do
  let(:user) { create(:user, email: "user@education.gov.uk") }
  let(:project) { create(:project, caseworker: user) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "User views project information" do
    visit project_information_path(project_id)

    expect(page).to have_content("Project details")
    page_has_project_information_list_row(label: "Caseworker", information: "John Doe", link: "user@education.gov.uk")
    page_has_project_information_list_row(label: "Team lead", information: "Team Leader", link: project.team_leader.email)
    page_has_project_information_list_row(label: "Regional delivery officer", information: "Regional Delivery-Officer", link: project.regional_delivery_officer.email)

    expect(page).to have_content("School details")
    page_has_project_information_list_row(label: "Original school name", information: "Caludon Castle School")
    page_has_project_information_list_row(label: "Old Unique Reference Number", information: "123456")
    page_has_project_information_list_row(label: "School type", information: "Academy converter")
    page_has_project_information_list_row(label: "Age range", information: "11 to 18")
    page_has_project_information_list_row(label: "School phase", information: "Secondary")

    expect(page).to have_content("Trust details")
    page_has_project_information_list_row(label: "Incoming trust name", information: "THE ROMERO CATHOLIC ACADEMY")
    page_has_project_information_list_row(label: "UK Provider Reference Number", information: "10061021")
    page_has_project_information_list_row(label: "Companies House number", information: "09702162")

    expect(page).to have_content("Local authority details")
    page_has_project_information_list_row(label: "Local authority", information: "West Placefield Council")

    expect(page).to have_content(I18n.t("project_information.show.diocese_details.title"))
    page_has_project_information_list_row(
      label: I18n.t("project_information.show.diocese_details.rows.diocese"),
      information: project.establishment.diocese_name
    )
  end

  private def page_has_project_information_list_row(label:, information:, link: nil)
    project_information_list = page.find("#projectInformationList")

    within project_information_list do
      label = find("dt", text: label)
      row_value = label.ancestor(".govuk-summary-list__row").find("dd")

      expect(row_value).to have_content(information)
      expect(row_value).to have_link(link) if link.present?
    end
  end
end
