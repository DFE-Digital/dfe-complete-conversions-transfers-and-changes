require "rails_helper"

RSpec.feature "Users can view internal contacts for a project" do
  include ActionView::Helpers::TextHelper

  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
    visit project_internal_contacts_path(project_id)
  end

  let(:project) { create(:conversion_project, :with_team_lead_and_regional_delivery_officer_assigned, caseworker: user, assigned_to: user) }

  scenario "they can view the name and email of the user assigned to the project" do
    within("#projectInternalContacts") do
      expect(page).to have_content(project.regional_delivery_officer.full_name)
      expect(page).to have_link("Email added by", href: "mailto:#{project.regional_delivery_officer.email}")
    end
  end

  scenario "they can view the name and email of the user that added the the project" do
    within("#projectInternalContacts") do
      expect(page).to have_content(project.regional_delivery_officer.full_name)
      expect(page).to have_link("Email added by", href: "mailto:#{project.regional_delivery_officer.email}")
    end
  end

  scenario "they can view the team assigned to the project" do
    within("#projectInternalContacts") do
      expect(page).to have_content(I18n.t("teams.#{project.team}"))
    end
  end
end
