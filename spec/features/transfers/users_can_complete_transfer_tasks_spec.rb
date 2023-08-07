require "rails_helper"

RSpec.feature "Users can complete conversion tasks" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:project) { create(:transfer_project, assigned_to: user) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
    visit project_tasks_path(project)
  end

  describe "the confirm all conditions met task" do
    scenario "they can confirm all conditions have been met" do
      visit project_tasks_path(project)
      click_on "Confirm all conditions have been met"
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.all_conditions_met).to be true
    end
  end
end
