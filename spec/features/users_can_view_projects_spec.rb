require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  before do
    mock_successful_api_responses(urn: 1001, ukprn: 10061021)
    mock_successful_api_responses(urn: 1002, ukprn: 10061021)
    mock_successful_api_responses(urn: 1003, ukprn: 10061021)
  end

  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let(:user_1) { create(:user, email: "user1@education.gov.uk") }
  let(:user_2) { create(:user, email: "user2@education.gov.uk") }
  let!(:unassigned_project) { create(:project, urn: 1001) }
  let!(:user_1_project) { create(:project, urn: 1002, delivery_officer: user_1) }
  let!(:user_2_project) { create(:project, urn: 1003, delivery_officer: user_2) }

  context "the user is a team leader" do
    before do
      sign_in_with_user(team_leader)
    end

    scenario "can see all projects on the project list regardless of assignment" do
      visit projects_path

      expect(page).to have_content(unassigned_project.urn.to_s)
      expect(page).to have_content(user_1_project.urn.to_s)
      expect(page).to have_content(user_2_project.urn.to_s)
    end
  end

  context "the user is not a team leader" do
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
end

RSpec.feature "Users can view a single project" do
  let(:urn) { 19283746 }
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

  context "when a project does not have an assigned delivery officer" do
    scenario "the project list shows an unassigned delivery officer" do
      sign_in_with_user(create(:user, :team_leader))
      create(:project, urn: 19283746)

      visit projects_path
      expect(page).to have_content(I18n.t("project.summary.delivery_officer.unassigned"))
    end

    scenario "the project page shows an unassigned delivery officer" do
      sign_in_with_user(create(:user, :team_leader))
      single_project = create(:project, urn: urn)

      visit project_information_path(single_project)
      expect(page).to have_content(I18n.t("project.summary.delivery_officer.unassigned"))
    end
  end

  context "when a project has an assigned delivery officer" do
    let(:user_email_address) { "user@education.gov.uk" }

    scenario "the project list shows an assigned delivery officer" do
      sign_in_with_user(create(:user, :team_leader, email: user_email_address))
      user = User.find_by(email: user_email_address)
      create(:project, urn: 19283746, delivery_officer: user)

      visit projects_path
      expect(page).to have_content(user_email_address)
    end

    scenario "the project page shows an assigned delivery officer" do
      sign_in_with_user(create(:user, :team_leader, email: user_email_address))
      user = User.find_by(email: user_email_address)
      single_project = create(:project, urn: urn, delivery_officer: user)

      visit project_information_path(single_project.id)
      expect(page).to have_content(user_email_address)
    end
  end
end
