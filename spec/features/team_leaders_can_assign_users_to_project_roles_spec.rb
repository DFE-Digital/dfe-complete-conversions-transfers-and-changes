require "rails_helper"

RSpec.feature "Team leaders can assign users to project roles" do
  let!(:team_leader) { create(:user, team_leader: true) }
  let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let!(:caseworker) { create(:user, :caseworker) }
  let(:user) { create(:user, :team_leader) }
  let(:project) { create(:conversion_project, :without_any_assigned_roles) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "Team leader assigns a user to the team leader role" do
    visit conversion_project_information_path(project_id)

    team_leader_summary_list_row = -> { page.find("dt", text: "Team lead").ancestor(".govuk-summary-list__row") }

    within team_leader_summary_list_row.call do
      expect(page).to have_content "Not yet assigned"

      click_on "Change"
    end

    expect(page).to have_current_path(conversion_project_assign_team_lead_path(project))

    select team_leader.full_name, from: I18n.t("assignment.assign_team_leader.title", school_name: project.establishment.name)

    click_on "Continue"

    within team_leader_summary_list_row.call do
      expect(page).to have_content team_leader.full_name
    end
  end

  scenario "Team leader assigns a user to the regional delivery officer role" do
    visit conversion_project_information_path(project_id)

    regional_delivery_officer_summary_list_row = -> { page.find("dt", text: "Regional delivery officer").ancestor(".govuk-summary-list__row") }

    within regional_delivery_officer_summary_list_row.call do
      expect(page).to have_content "Not yet assigned"

      click_on "Change"
    end

    expect(page).to have_current_path(conversion_project_assign_regional_delivery_officer_path(project))

    select regional_delivery_officer.full_name, from: I18n.t("assignment.assign_regional_delivery_officer.title", school_name: project.establishment.name)

    click_on "Continue"

    within regional_delivery_officer_summary_list_row.call do
      expect(page).to have_content regional_delivery_officer.full_name
    end
  end

  scenario "Team leader assigns a user to the caseworker role" do
    visit conversion_project_information_path(project_id)

    caseworker_summary_list_row = -> { page.find("dt", text: "Caseworker").ancestor(".govuk-summary-list__row") }

    within caseworker_summary_list_row.call do
      expect(page).to have_content "Not yet assigned"

      click_on "Change"
    end

    expect(page).to have_current_path(conversion_project_assign_caseworker_path(project))

    select caseworker.full_name, from: I18n.t("assignment.assign_caseworker.title", school_name: project.establishment.name)

    click_on "Continue"

    within caseworker_summary_list_row.call do
      expect(page).to have_content caseworker.full_name
    end
  end
end
