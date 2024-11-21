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
    commercial_transfer_agreement
    confirm_incoming_trust_has_completed_all_actions
    deed_of_novation_and_variation
    redact_and_send_documents
    rpa_policy
    supplemental_funding_agreement
  ]

  optional_tasks = %w[
    articles_of_association
    church_supplemental_agreement
    closure_or_transfer_declaration
    deed_of_termination_for_the_master_funding_agreement
    deed_of_variation
    deed_termination_church_agreement
    form_m
    handover
    land_consent_letter
    master_funding_agreement
    request_new_urn_and_record
  ]

  tasks_with_collected_data = %w[
    stakeholder_kick_off
    confirm_headteacher_contact
    confirm_incoming_trust_ceo_contact
    confirm_outgoing_trust_ceo_contact
    main_contact
    confirm_date_academy_transferred
    check_and_confirm_financial_information
    conditions_met
    declaration_of_expenditure_certificate
    sponsored_support_grant
    bank_details_changing
  ]

  it "confirms we are checking all tasks" do
    # If this test fails, we have added or removed a task from the page
    # and need to add or remove it from the arrays above
    tasks_we_are_testing = mandatory_tasks.count + optional_tasks.count + tasks_with_collected_data.count
    tasks_on_page = page.find_all("ol.app-task-list ul li a").count
    expect(tasks_on_page).to eq tasks_we_are_testing
  end

  mandatory_tasks.each do |task|
    scenario "a user can complete the actions on the mandatory #{I18n.t("transfer.task.#{task}.title")} task" do
      click_on I18n.t("transfer.task.#{task}.title")
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.#{task}.title"))
      expect(table_row).to have_content("Completed")
    end
  end

  optional_tasks.each do |task|
    scenario "a user can mark an optional task #{I18n.t("transfer.task.#{task}.title")} as not applicable" do
      click_on I18n.t("transfer.task.#{task}.title")
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.#{task}.title"))
      expect(table_row).to have_content("Not applicable")
    end
  end

  optional_tasks.each do |task|
    scenario "a user can complete the actions on the optional task #{I18n.t("transfer.task.#{task}.title")}" do
      click_on I18n.t("transfer.task.#{task}.title")
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      # uncheck the Not applicable box
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.#{task}.title"))
      expect(table_row).to have_content("Completed")
    end
  end

  # A special scenario for the only radio button task
  scenario "a user can complete the task Confirm if the bank details for the general annual grant payment need to change" do
    table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.bank_details_changing.title"))
    expect(table_row).to have_content("Not started")
    click_on I18n.t("transfer.task.bank_details_changing.title")
    choose "Yes"
    click_on I18n.t("task_list.continue_button.text")
    table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.bank_details_changing.title"))
    expect(table_row).to have_content("Completed")
  end
end
