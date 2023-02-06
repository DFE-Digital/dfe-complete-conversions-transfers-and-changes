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

  context "when the caseworker, team lead and regional delivery officer have been assigned" do
    let(:project) { create(:conversion_project, :with_team_lead_and_regional_delivery_officer_assigned, caseworker: user) }

    scenario "they can view the users names and email addresses assigned to the project" do
      within("#projectInternalContacts") do
        expect(page).to have_content(user.full_name)
        expect(page).to have_link("Email caseworker", href: "mailto:#{user.email}")

        expect(page).to have_content(project.team_leader.full_name)
        expect(page).to have_link("Email team leader", href: "mailto:#{project.team_leader.email}")

        expect(page).to have_content(project.regional_delivery_officer.full_name)
        expect(page).to have_link("Email regional delivery officer", href: "mailto:#{project.regional_delivery_officer.email}")
      end
    end
  end

  context "when a project does not have an assigned caseworker" do
    let(:project) { create(:conversion_project) }

    scenario "the project page shows an unassigned caseworker" do
      expect(page).to have_content(I18n.t("project.summary.caseworker.unassigned"))
    end
  end
end
