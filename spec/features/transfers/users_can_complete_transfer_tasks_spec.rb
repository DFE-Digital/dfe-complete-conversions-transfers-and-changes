require "rails_helper"

RSpec.feature "Users can complete transfer tasks" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:project) { create(:transfer_project, assigned_to: user) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
    visit project_tasks_path(project)
  end

  mandatory_tasks = %w[
    deed_of_novation_and_variation
    commercial_transfer_agreement
    form_m
    rpa_policy
    supplemental_funding_agreement
    confirm_incoming_trust_has_completed_all_actions
  ]

  optional_tasks = %w[
    handover
    deed_of_variation
    articles_of_association
    land_consent_letter
    church_supplemental_agreement
    deed_termination_church_agreement
    master_funding_agreement
    deed_of_termination_for_the_master_funding_agreement
    closure_or_transfer_declaration
  ]

  tasks_with_collected_data = %w[
    stakeholder_kick_off
    conditions_met
    main_contact
  ]

  it "confirms that all tasks are tested here" do
    number_of_tasks = Transfer::TaskList.new(project, user).all_tasks.count
    number_of_tested_tasks = mandatory_tasks.count + optional_tasks.count + tasks_with_collected_data.count
    expect(number_of_tested_tasks).to eq number_of_tasks
  end

  describe "required tasks" do
    mandatory_tasks.each do |task|
      scenario "complete the actions on the mandatory #{I18n.t("transfer.task.#{task}.title")} task" do
        click_on I18n.t("transfer.task.#{task}.title")
        click_all_action_checkboxes(page)

        click_on I18n.t("task_list.continue_button.text")
        table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.#{task}.title"))

        expect(table_row).to have_content("Completed")
      end
    end
  end

  describe "optional tasks" do
    optional_tasks.each do |task|
      scenario "mark an optional task #{I18n.t("transfer.task.#{task}.title")} as not applicable" do
        click_on I18n.t("transfer.task.#{task}.title")
        click_not_applicable(page)

        click_on I18n.t("task_list.continue_button.text")
        table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.#{task}.title"))

        expect(table_row).to have_content("Not applicable")
      end
    end

    optional_tasks.each do |task|
      scenario "complete the actions on the optional task #{I18n.t("transfer.task.#{task}.title")}" do
        click_on I18n.t("transfer.task.#{task}.title")
        click_all_action_checkboxes(page)
        click_not_applicable(page)

        click_on I18n.t("task_list.continue_button.text")
        table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.#{task}.title"))

        expect(table_row).to have_content("Completed")
      end
    end
  end

  def click_all_action_checkboxes(page)
    page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
  end

  def click_not_applicable(page)
    page.find(".govuk-checkboxes__label", text: "Not applicable").click
  end
end
