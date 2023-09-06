require "rails_helper"

RSpec.feature "Users can complete the stakeholder kick off task" do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
    visit project_tasks_path(project)
  end

  describe "the stakeholder kick-off task" do
    context "when the project transfer date is provisional" do
      let(:project) { create(:transfer_project, assigned_to: user, transfer_date_provisional: true) }

      scenario "they can set the confirmed date" do
        visit project_tasks_path(project)

        click_on "External stakeholder kick-off"
        page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
        within(".app-confirmed-transfer-date") do
          completion_date = Date.today + 1.year
          fill_in "Month", with: completion_date.month
          fill_in "Year", with: completion_date.year
        end
        click_on I18n.t("task_list.continue_button.text")
        table_row = page.find("li.app-task-list__item", text: "External stakeholder kick-off")
        expect(table_row).to have_content("Completed")
      end
    end

    context "when the project transfer date is confirmed" do
      let(:project) { create(:transfer_project, assigned_to: user, transfer_date_provisional: false) }

      scenario "they can continue to submit the task form" do
        visit project_tasks_path(project)

        click_on "External stakeholder kick-off"
        page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
        click_on I18n.t("task_list.continue_button.text")
        table_row = page.find("li.app-task-list__item", text: "External stakeholder kick-off")
        expect(table_row).to have_content("Completed")
      end
    end
  end
end
