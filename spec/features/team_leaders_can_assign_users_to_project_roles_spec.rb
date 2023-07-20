require "rails_helper"

RSpec.feature "Team leaders can assign users to project roles" do
  let!(:team_leader) { create(:user, manage_team: true) }
  let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer, first_name: "John") }
  let!(:caseworker) { create(:user, :caseworker, first_name: "Jane") }
  let(:user) { create(:user, :team_leader, first_name: "Jason") }
  let(:project) { create(:conversion_project, :without_any_assigned_roles) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "Team leader assigns a user to the regional delivery officer role" do
    visit project_internal_contacts_path(project_id)

    regional_delivery_officer_summary_list_row = -> { page.find("dt", text: I18n.t("contact.internal_contacts.added_by")).ancestor(".govuk-summary-list__row") }

    within regional_delivery_officer_summary_list_row.call do
      expect(page).to have_content "Not yet assigned"

      click_on "Change"
    end

    expect(page).to have_current_path(project_assign_regional_delivery_officer_path(project))

    select regional_delivery_officer.full_name, from: I18n.t("assignment.assign_regional_delivery_officer.title", school_name: project.establishment.name)

    click_on "Continue"

    within regional_delivery_officer_summary_list_row.call do
      expect(page).to have_content regional_delivery_officer.full_name
    end
  end

  scenario "Team leader assigns a user to the assigned_to role" do
    visit project_internal_contacts_path(project_id)

    assigned_to_summary_list_row = -> { page.find("dt", text: "Assigned to user").ancestor(".govuk-summary-list__row") }

    within assigned_to_summary_list_row.call do
      expect(page).to have_content "Not yet assigned"

      click_on "Change"
    end

    expect(page).to have_current_path(project_assign_assigned_to_path(project))

    select caseworker.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: project.establishment.name)

    click_on "Continue"

    within assigned_to_summary_list_row.call do
      expect(page).to have_content caseworker.full_name
    end
  end
end
