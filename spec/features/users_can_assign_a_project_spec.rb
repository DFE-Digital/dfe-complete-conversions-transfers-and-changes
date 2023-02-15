require "rails_helper"

RSpec.feature "Any user can assign any other user to a project" do
  let!(:team_leader) { create(:user, team_leader: true, first_name: "Bobbie") }
  let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer, first_name: "Chris") }
  let!(:caseworker) { create(:user, :caseworker, first_name: "Alex") }

  let(:project) { create(:conversion_project) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  context "The user is a caseworker" do
    let(:user) { caseworker }

    scenario "The caseworker can assign another user to a project" do
      visit conversions_voluntary_project_internal_contacts_path(project_id)

      assigned_to_summary_list_row = -> { page.find("dt", text: "Assigned to").ancestor(".govuk-summary-list__row") }

      within assigned_to_summary_list_row.call do
        expect(page).to have_content "Not yet assigned"

        click_on "Change"
      end

      expect(page).to have_current_path(conversions_voluntary_project_assign_assigned_to_path(project))

      select team_leader.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: project.establishment.name)

      click_on "Continue"

      within assigned_to_summary_list_row.call do
        expect(page).to have_content team_leader.full_name
      end
    end
  end

  context "The user is a team leader" do
    let(:user) { team_leader }

    scenario "The team leader can assign another user to a project" do
      visit conversions_voluntary_project_internal_contacts_path(project_id)

      assigned_to_summary_list_row = -> { page.find("dt", text: "Assigned to").ancestor(".govuk-summary-list__row") }

      within assigned_to_summary_list_row.call do
        expect(page).to have_content "Not yet assigned"

        click_on "Change"
      end

      expect(page).to have_current_path(conversions_voluntary_project_assign_assigned_to_path(project))

      select regional_delivery_officer.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: project.establishment.name)

      click_on "Continue"

      within assigned_to_summary_list_row.call do
        expect(page).to have_content regional_delivery_officer.full_name
      end
    end
  end

  context "The user is a regional delivery officer" do
    let(:user) { regional_delivery_officer }

    scenario "The regional delivery officer can assign another user to a project" do
      visit conversions_voluntary_project_internal_contacts_path(project_id)

      assigned_to_summary_list_row = -> { page.find("dt", text: "Assigned to").ancestor(".govuk-summary-list__row") }

      within assigned_to_summary_list_row.call do
        expect(page).to have_content "Not yet assigned"

        click_on "Change"
      end

      expect(page).to have_current_path(conversions_voluntary_project_assign_assigned_to_path(project))

      select caseworker.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: project.establishment.name)

      click_on "Continue"

      within assigned_to_summary_list_row.call do
        expect(page).to have_content caseworker.full_name
      end
    end
  end
end
