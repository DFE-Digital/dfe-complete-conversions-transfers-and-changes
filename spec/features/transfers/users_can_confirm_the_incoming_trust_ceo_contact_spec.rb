require "rails_helper"

RSpec.feature "Users can confirm the incoming trust CEO contact" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:transfer_project, assigned_to: user) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when there are no contacts for the project" do
    scenario "they see a helpful message and a link to the contacts tab" do
      visit project_path(project)
      click_link "Confirm the incoming trust CEO’s details"

      expect(page).to have_content "No contacts have been added to the project."
      expect(page).to have_link href: project_contacts_path(project), text: "edit incorrect contact details and add missing contacts"
    end
  end

  context "when there are contacts but they are not in the correct category" do
    let!(:contact) { create(:project_contact, category: :school_or_academy, project: project) }

    scenario "they see a helpful message and a link to the contacts tab" do
      visit project_path(project)
      click_link "Confirm the incoming trust CEO’s details"

      expect(page).to have_content "No contacts have been added to the project."
      expect(page).to have_link href: project_contacts_path(project), text: "edit incorrect contact details and add missing contacts"
    end
  end

  context "when there are contacts and they are in the correct category" do
    let!(:contact) { create(:project_contact, category: :incoming_trust, project: project) }

    scenario "they can choose the contact" do
      visit project_path(project)
      click_link "Confirm the incoming trust CEO’s details"

      expect(page).to have_content contact.name
      expect(page).to have_content contact.email
      expect(page).to have_content contact.phone

      choose contact.name

      click_button "Save and return"

      within ".app-task-list li:nth-of-type(1) li:nth-of-type(4)" do
        expect(page).to have_content "Completed"
      end
    end
  end
end
