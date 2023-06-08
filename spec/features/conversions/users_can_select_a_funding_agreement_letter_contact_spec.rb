require "rails_helper"

RSpec.feature "Users select a contact to receive the funding agreement letters" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, assigned_to: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  context "when the project already has some contacts" do
    let!(:contact_1) { create(:project_contact, project: project, name: "John Smith") }
    let!(:contact_2) { create(:project_contact, project: project, name: "Jane Jones") }

    it "allows the user to select one of the existing contacts on the Funding Agreement Letters task page" do
      visit project_conversion_tasks_path(project)
      click_on "Confirm who will get the funding agreement letters"
      expect(page).to have_content(contact_1.name)
      expect(page).to have_content(contact_2.name)

      choose contact_1.name
      click_button "Save and return"

      expect(project.reload.funding_agreement_contact_id).to eq(contact_1.id)
      expect(page.find("#confirm-who-will-get-the-funding-agreement-letters-status").text).to eq("Completed")
    end
  end

  context "when the project already has a funding agreement letters contact set" do
    let!(:contact_1) { create(:project_contact, project: project, name: "John Smith") }
    let!(:contact_2) { create(:project_contact, project: project, name: "Jane Jones") }

    before do
      project.update(funding_agreement_contact_id: contact_2.id)
    end

    it "shows the contact as preselected on the Funding Agreement Letters task page" do
      visit project_conversion_tasks_path(project)
      click_on "Confirm who will get the funding agreement letters"

      expect(page).to have_checked_field(contact_2.name)
    end

    context "and the funding agreement letters contact is changed" do
      it "switches the contact for the project" do
        visit project_conversion_tasks_path(project)
        click_on "Confirm who will get the funding agreement letters"

        choose contact_1.name
        click_on "Save and return"

        expect(project.reload.funding_agreement_contact_id).to eq(contact_1.id)
      end
    end
  end

  context "when the project does not have any contacts" do
    it "directs the user to the external contacts page" do
      visit project_conversion_tasks_path(project)
      click_on "Confirm who will get the funding agreement letters"

      expect(page).to have_content("Add contacts")
      click_link "add a contact"
      expect(page.current_path).to include("external-contacts")
    end

    it "allows the user to go back to the task list without adding a user" do
      visit project_conversion_tasks_path(project)
      click_on "Confirm who will get the funding agreement letters"

      expect(page).to have_content("Add contacts")
      click_link "Save and return"
      expect(page.find("#confirm-who-will-get-the-funding-agreement-letters-status").text).to eq("Not started")
    end
  end
end
