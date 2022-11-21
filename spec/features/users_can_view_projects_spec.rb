require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  before do
    mock_successful_api_responses(urn: 100001, ukprn: 10061021)
    mock_successful_api_responses(urn: 100002, ukprn: 10061021)
    mock_successful_api_responses(urn: 100003, ukprn: 10061021)
    mock_successful_api_responses(urn: 100004, ukprn: 10061021)
  end

  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer, email: "regionaldeliveryofficer@education.gov.uk") }
  let(:user_1) { create(:user, email: "user1@education.gov.uk") }
  let(:user_2) { create(:user, email: "user2@education.gov.uk") }
  let!(:unassigned_project) {
    create(
      :conversion_project,
      urn: 100001,
      provisional_conversion_date: Date.today.beginning_of_month + 3.years
    )
  }
  let!(:user_1_project) {
    create(
      :conversion_project,
      urn: 100002,
      caseworker: user_1,
      provisional_conversion_date: Date.today.beginning_of_month + 2.year
    )
  }
  let!(:user_2_completed_project) {
    create(
      :conversion_project,
      urn: 100004,
      caseworker: user_2,
      regional_delivery_officer: regional_delivery_officer,
      provisional_conversion_date: Date.today.beginning_of_month + 6.months,
      completed_at: Date.today.beginning_of_month + 7.months
    )
  }
  let!(:user_2_project) {
    create(
      :conversion_project,
      urn: 100003,
      caseworker: user_2,
      regional_delivery_officer: regional_delivery_officer,
      provisional_conversion_date: Date.today.beginning_of_month + 1.years
    )
  }

  context "when the user is a team leader" do
    before do
      sign_in_with_user(team_leader)
    end

    scenario "can see all open projects on the project list regardless of assignment" do
      visit conversion_projects_path

      page_has_project(unassigned_project)
      page_has_project(user_1_project)
      page_has_project(user_2_project)
    end

    scenario "can see the completed project on a separate tab" do
      visit completed_conversion_projects_path

      page_has_project(user_2_completed_project)
    end

    scenario "the open projects are sorted by target completion date" do
      visit conversion_projects_path

      expect(page.find("ul.projects-list > li:nth-of-type(1)")).to have_content("100003")
      expect(page.find("ul.projects-list > li:nth-of-type(2)")).to have_content("100002")
      expect(page.find("ul.projects-list > li:nth-of-type(3)")).to have_content("100001")
    end
  end

  context "when the user is a regional delivery officer" do
    before do
      sign_in_with_user(regional_delivery_officer)
    end

    scenario "can only see assigned projects on the projects list" do
      visit conversion_projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).not_to have_content(user_1_project.urn.to_s)
      page_has_project(user_2_project)
    end
  end

  context "when the user does not have an assigned role" do
    before(:each) do
      sign_in_with_user(user_1)
    end

    scenario "can only see assigned projects on the projects list" do
      visit conversion_projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).to have_content(user_1_project.urn.to_s)
      expect(page).to_not have_content(user_2_project.urn.to_s)
    end
  end

  context "when there are no projects in a project list" do
    before do
      sign_in_with_user(user_1)
      ConversionProject.destroy_all
    end

    scenario "there is a message indicating there are no open projects" do
      visit conversion_projects_path

      expect(page).to have_content(I18n.t("project_list.open_list_empty"))
    end

    scenario "there is a message indicating there are no completed projects" do
      visit completed_conversion_projects_path

      expect(page).to have_content(I18n.t("project_list.completed_list_empty"))
    end
  end

  private def page_has_project(project)
    urn = find("span", text: project.urn.to_s)

    within urn.ancestor("li") do
      expect(page).to have_content("School type: #{project.establishment.type}")
      expect(page).to have_content("Provisional conversion date: #{project.provisional_conversion_date.to_formatted_s(:govuk)}")
      expect(page).to have_content("Incoming trust: #{project.incoming_trust.name}")
      expect(page).to have_content("Local authority: #{project.establishment.local_authority}")
    end
  end
end

RSpec.feature "Users can view a single project" do
  let(:urn) { 123456 }
  let(:establishment) { build(:academies_api_establishment) }

  before do
    mock_successful_api_establishment_response(urn: urn, establishment: establishment)
    mock_successful_api_responses(urn: urn, ukprn: 10061021)
  end

  scenario "by following a link from the home page" do
    sign_in_with_user(create(:user, :team_leader))

    single_project = create(:conversion_project, urn: urn)

    visit root_path
    click_on establishment.name
    expect(page).to have_content(single_project.urn.to_s)
  end

  context "when a project does not have an assigned caseworker" do
    scenario "the project page shows an unassigned caseworker" do
      sign_in_with_user(create(:user, :team_leader))
      single_project = create(:conversion_project, urn: urn)

      visit conversion_project_information_path(single_project)
      expect(page).to have_content(I18n.t("project.summary.caseworker.unassigned"))
    end
  end
end
