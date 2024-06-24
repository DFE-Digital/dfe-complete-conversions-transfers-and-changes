require "rails_helper"

RSpec.feature "Users select a main contact for a conversion" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, assigned_to: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  context "when the project already has some contacts" do
    let!(:contact_1) { create(:project_contact, project: project, name: "John Smith") }
    let!(:contact_2) { create(:project_contact, project: project, name: "Jane Jones") }

    it "allows the user to select one of the existing contacts on the Main Contact task page" do
      visit project_tasks_path(project)
      click_on "Confirm the main contact"
      expect(page).to have_content(contact_1.name)
      expect(page).to have_content(contact_2.name)

      choose contact_1.name
      click_button "Save and return"

      expect(project.reload.main_contact_id).to eq(contact_1.id)
      expect(page.find("#confirm-the-main-contact-status").text).to eq("Completed")
    end
  end

  context "when the project has contacts which were ingested, not manually added (e.g. Head teacher from GIAS)" do
    let!(:contact_1) { create(:establishment_contact, establishment_urn: project.urn, name: "John Headteacher") }
    let!(:contact_2) { create(:director_of_child_services, local_authority: project.local_authority, name: "Jane Director") }

    it "allows the user to select one of the ingested contacts on the Main Contact task page" do
      visit project_tasks_path(project)
      click_on "Confirm the main contact"
      expect(page).to have_content(contact_1.name)
      expect(page).to have_content(contact_2.name)

      choose contact_1.name
      click_button "Save and return"

      expect(project.reload.main_contact_id).to eq(contact_1.id)
      expect(page.find("#confirm-the-main-contact-status").text).to eq("Completed")
    end
  end

  context "when the project already has a main contact set" do
    let!(:contact_1) { create(:project_contact, project: project, name: "John Smith") }
    let!(:contact_2) { create(:project_contact, project: project, name: "Jane Jones") }

    before do
      project.update(main_contact_id: contact_2.id)
    end

    it "shows the contact as preselected on the Main Contact task page" do
      visit project_tasks_path(project)
      click_on "Confirm the main contact"

      expect(page).to have_checked_field(contact_2.name)
    end

    context "and the main contact is changed" do
      it "switches the contact for the project" do
        visit project_tasks_path(project)
        click_on "Confirm the main contact"

        choose contact_1.name
        click_on "Save and return"

        expect(project.reload.main_contact_id).to eq(contact_1.id)
      end
    end
  end

  context "when the project does not have any contacts" do
    it "directs the user to the external contacts page" do
      visit project_tasks_path(project)
      click_on "Confirm the main contact"

      expect(page).to have_content("Add a contact")
      click_link "add a contact"
      expect(page.current_path).to include("external-contacts")
    end

    it "allows the user to go back to the task list without adding a user" do
      visit project_tasks_path(project)
      click_on "Confirm the main contact"

      expect(page).to have_content("Add a contact")
      click_link "Save and return"
      expect(page.find("#confirm-the-main-contact-status").text).to eq("Not started")
    end
  end
end
