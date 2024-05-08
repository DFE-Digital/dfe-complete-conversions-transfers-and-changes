require "rails_helper"

RSpec.feature "Users can view internal contacts for a project" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, caseworker: user, assigned_to: user) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
    visit project_internal_contacts_path(project)
  end

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
