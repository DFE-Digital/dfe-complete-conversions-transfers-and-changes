require "rails_helper"

RSpec.feature "Users can view project information" do
  let(:user) { create(:user, email: "user@education.gov.uk") }
  let(:project) { create(:project, caseworker: user) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
    visit project_information_path(project_id)
  end

  describe "the project details" do
    scenario "have the appropriate values" do
      section = find("#projectDetails")
      page_has_project_information_list_row(section: section, label: "Caseworker", information: "user@education.gov.uk")
      page_has_project_information_list_row(section: section, label: "Team lead", information: project.team_leader.email)
      page_has_project_information_list_row(section: section, label: "Regional delivery officer", information: project.regional_delivery_officer.email)
    end
  end

  describe "the school details" do
    scenario "have the appropriate values" do
      section = find("#schoolDetails")
      page_has_project_information_list_row(section: section, label: "Original school name", information: "Caludon Castle School")
      page_has_project_information_list_row(section: section, label: "Old Unique Reference Number", information: "123456")
      page_has_project_information_list_row(section: section, label: "School type", information: "Academy converter")
      page_has_project_information_list_row(section: section, label: "Age range", information: "11 to 18")
      page_has_project_information_list_row(section: section, label: "School phase", information: "Secondary")
      page_has_project_information_list_row(
        section: section,
        label: I18n.t("project_information.show.school_details.rows.region"),
        information: project.establishment.region_name
      )
    end
  end

  describe "the trust details" do
    scenario "have the appropriate values" do
      section = find("#trustDetails")
      page_has_project_information_list_row(section: section, label: "Incoming trust name", information: "THE ROMERO CATHOLIC ACADEMY")
      page_has_project_information_list_row(section: section, label: "UK Provider Reference Number", information: "10061021")
      page_has_project_information_list_row(section: section, label: "Companies House number", information: "09702162")
    end
  end

  describe "the local authority details" do
    scenario "have the appropriate values" do
      section = find("#localAuthorityDetails")
      page_has_project_information_list_row(section: section, label: "Local authority", information: "West Placefield Council")
    end
  end

  describe "the diocese details" do
    scenario "have the appropriate values" do
      section = find("#dioceseDetails")
      page_has_project_information_list_row(
        section: section,
        label: I18n.t("project_information.show.diocese_details.rows.diocese"),
        information: project.establishment.diocese_name
      )
    end
  end

  private def page_has_project_information_list_row(section:, label:, information:)
    label = section.find("dt", text: label)
    information = section.find("dd", text: information)

    assert label
    assert information
  end
end
