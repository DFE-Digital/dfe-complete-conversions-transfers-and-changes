require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  before do
    mock_successful_api_responses(urn: 100001, ukprn: 10061021)
    mock_successful_api_responses(urn: 100002, ukprn: 10061021)
    mock_successful_api_responses(urn: 100003, ukprn: 10061021)
  end

  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer, email: "regionaldeliveryofficer@education.gov.uk") }
  let(:user_1) { create(:user, email: "user1@education.gov.uk") }
  let(:user_2) { create(:user, email: "user2@education.gov.uk") }
  let!(:unassigned_project) { create(:project, urn: 100001) }
  let!(:user_1_project) { create(:project, urn: 100002, caseworker: user_1) }
  let!(:user_2_project) { create(:project, urn: 100003, caseworker: user_2, regional_delivery_officer: regional_delivery_officer) }

  context "when the user is a team leader" do
    before do
      sign_in_with_user(team_leader)
    end

    scenario "can see all projects on the project list regardless of assignment" do
      visit projects_path

      page_has_project(unassigned_project)
      page_has_project(user_1_project)
      page_has_project(user_2_project)
    end
  end

  context "when the user is a regional delivery officer" do
    before do
      sign_in_with_user(regional_delivery_officer)
    end

    scenario "can only see assigned projects on the projects list" do
      visit projects_path

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
      visit projects_path

      expect(page).to_not have_content(unassigned_project.urn.to_s)
      expect(page).to have_content(user_1_project.urn.to_s)
      expect(page).to_not have_content(user_2_project.urn.to_s)
    end
  end

  private def page_has_project(project)
    urn = find("span", text: project.urn.to_s)

    within urn.ancestor("li") do
      expect(page).to have_content("School type: #{project.establishment.type}")
      expect(page).to have_content("Target conversion date: #{project.target_completion_date.to_formatted_s(:govuk)}")
      expect(page).to have_content("Incoming trust: #{project.trust.name}")
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

    single_project = create(:project, urn: urn)

    visit root_path
    click_on establishment.name
    expect(page).to have_content(single_project.urn.to_s)
  end

  context "when a project does not have an assigned caseworker" do
    scenario "the project page shows an unassigned caseworker" do
      sign_in_with_user(create(:user, :team_leader))
      single_project = create(:project, urn: urn)

      visit project_information_path(single_project)
      expect(page).to have_content(I18n.t("project.summary.caseworker.unassigned"))
    end
  end

  context "when a project has an assigned caseworker" do
    let(:user_email_address) { "user@education.gov.uk" }

    scenario "the project list shows an assigned caseworker" do
      sign_in_with_user(create(:user, :team_leader, email: user_email_address))
      user = User.find_by(email: user_email_address)
      create(:project, urn: 123456, caseworker: user)

      visit projects_path
      expect(page).to have_content(user_email_address)
    end

    scenario "the project page shows an assigned caseworker" do
      sign_in_with_user(create(:user, :team_leader, email: user_email_address))
      user = User.find_by(email: user_email_address)
      single_project = create(:project, urn: urn, caseworker: user)

      visit project_information_path(single_project.id)
      expect(page).to have_content(user_email_address)
    end
  end
end
