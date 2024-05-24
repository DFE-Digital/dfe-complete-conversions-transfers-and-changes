require "rails_helper"

RSpec.feature "Users can complete the authority to proceed" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:project) { create(:transfer_project, assigned_to: user) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
    visit project_tasks_path(project)
  end

  describe "the authority to proceed task" do
    scenario "they can confirm the transfer has authority to proceed" do
      visit project_tasks_path(project)
      click_on "Confirm this transfer has authority to proceed"
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.authority_to_proceed).to be true
    end
  end
end
