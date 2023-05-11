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

  context "when the regional delivery officer and assigned_to person have been assigned" do
    let(:project) { create(:conversion_project, :with_team_lead_and_regional_delivery_officer_assigned, caseworker: user, assigned_to: user) }

    scenario "they can view the users names and email addresses assigned to the project" do
      within("#projectInternalContacts") do
        expect(page).to have_content(project.assigned_to.full_name)
        expect(page).to have_link("Email assigned to", href: "mailto:#{project.assigned_to.email}")

        expect(page).to have_content(project.regional_delivery_officer.full_name)
        expect(page).to have_link("Email regional delivery officer", href: "mailto:#{project.regional_delivery_officer.email}")
      end
    end
  end
end
