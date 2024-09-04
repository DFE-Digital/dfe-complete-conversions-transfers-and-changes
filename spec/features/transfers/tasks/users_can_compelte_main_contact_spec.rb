require "rails_helper"

RSpec.feature "Users can complete the main contact task" do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    mock_all_academies_api_responses
    mock_successful_persons_api_client
    sign_in_with_user(user)
    visit project_tasks_path(project)
  end

  context "the main contact task" do
    let(:project) { create(:transfer_project, assigned_to: user) }

    context "when the project has contacts already" do
      let!(:contact) { create(:project_contact, project: project) }

      it "lets the user select an existing contact" do
        visit project_tasks_path(project)
        click_on "Confirm the main contact"
        choose contact.name
        click_on I18n.t("task_list.continue_button.text")

        expect(project.reload.main_contact_id).to eq contact.id
      end
    end

    context "when the project has no contacts" do
      it "directs the user to add contacts" do
        visit project_tasks_path(project)
        click_on "Confirm the main contact"

        expect(page).to have_content("Add contacts")
        click_link "add a contact"
        expect(page.current_path).to include("external-contacts")
      end
    end
  end
end
