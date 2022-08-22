require "rails_helper"

RSpec.feature "Users can reach the edit project page" do
  let(:urn) { 123456 }
  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let(:caseworker) { create(:user, email: "user1@education.gov.uk") }
  let(:unassigned_project) { create(:project, urn: urn) }

  before { mock_successful_api_responses(urn: urn, ukprn: 10061021) }

  context "the user is a team leader" do
    before do
      sign_in_with_user(team_leader)
    end

    scenario "by following a link from the show project page" do
      visit project_path(unassigned_project)
      click_on I18n.t("project.show.edit_button.text")
      expect(page).to have_content(I18n.t("project.edit.title"))
      expect(page).to have_content(unassigned_project.urn.to_s)
    end

    scenario "by visiting the edit project page directly" do
      visit edit_project_path(unassigned_project)
      expect(page).to have_content(I18n.t("project.edit.title"))
      expect(page).to have_content(unassigned_project.urn.to_s)
    end
  end

  context "the user is not a team leader" do
    let(:user_1_project) { create(:project, urn: urn, caseworker: caseworker) }

    before do
      sign_in_with_user(caseworker)
    end

    scenario "there is no edit link on the show project page" do
      visit project_path(user_1_project)
      expect(page).to_not have_content(I18n.t("project.show.edit_button.text"))
    end

    scenario "cannot visit edit project page directly" do
      visit edit_project_path(user_1_project)
      expect(page).to have_content(I18n.t("unauthorised_action.message"))
    end
  end
end

RSpec.feature "Users can update a project" do
  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let!(:caseworker) { create(:user, email: "user1@education.gov.uk") }
  let!(:caseworker_2) { create(:user, email: "user2@education.gov.uk") }

  context "the user is a team leader" do
    before do
      sign_in_with_user(team_leader)
      mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    end

    context "when the project has no caseworker" do
      let(:unassigned_project) { create(:project) }

      scenario "the caseworker can be set" do
        visit edit_project_path(unassigned_project)
        select caseworker.email, from: "project-caseworker-id-field"
        click_on "Continue"
        expect(page).to have_content(caseworker.email)
      end
    end

    context "when the project already has a caseworker" do
      let(:assigned_project) { create(:project, caseworker: caseworker) }

      scenario "the caseworker can be changed" do
        caseworker_2
        visit edit_project_path(assigned_project)
        select caseworker_2.email, from: "project-caseworker-id-field"
        click_on "Continue"
        expect(page).to have_content(caseworker_2.email)
      end

      scenario "the caseworker can be unset" do
        visit edit_project_path(assigned_project)
        select "", from: "project-caseworker-id-field"
        click_on "Continue"
        expect(page).to have_content(I18n.t("project.summary.caseworker.unassigned"))
      end
    end
  end
end
