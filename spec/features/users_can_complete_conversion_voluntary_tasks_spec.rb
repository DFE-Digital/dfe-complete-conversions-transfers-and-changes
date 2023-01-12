require "rails_helper"

RSpec.feature "Users can complete tasks in a voluntary conversion project" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:voluntary_project) { create(:voluntary_conversion_project) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit conversions_voluntary_project_task_list_path(voluntary_project.id)
  end

  mandatory_tasks = %w[check_baseline commercial_transfer_agreement
    conditions_met conversion_grant handover
    land_questionnaire land_registry
    receive_grant_payment_certificate redact_and_send
    school_completed share_information single_worksheet stakeholder_kick_off
    supplemental_funding_agreement
    tell_regional_delivery_officer update_esfa]

  optional_tasks = %w[articles_of_association church_supplemental_agreement
    deed_of_variation direction_to_transfer master_funding_agreement
    one_hundred_and_twenty_five_year_lease subleases tenancy_at_will
    trust_modification_order]

  it "confirms we are checking all tasks" do
    # If this test fails, we have added or removed a task from the page
    # and need to add or remove it from the arrays above
    tasks_we_are_testing = mandatory_tasks.count + optional_tasks.count
    tasks_on_page = page.find_all("ol.app-task-list ul li a").count
    expect(tasks_on_page).to eq tasks_we_are_testing
  end

  mandatory_tasks.each do |task|
    scenario "a user can complete the actions on the mandatory #{I18n.t("conversion.voluntary.tasks.#{task}.title")} task" do
      click_on I18n.t("conversion.voluntary.tasks.#{task}.title")
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.voluntary.tasks.#{task}.title"))
      expect(table_row).to have_content("Completed")
    end
  end

  optional_tasks.each do |task|
    scenario "a user can mark an optional task #{I18n.t("conversion.voluntary.tasks.#{task}.title")} as not applicable" do
      click_on I18n.t("conversion.voluntary.tasks.#{task}.title")
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.voluntary.tasks.#{task}.title"))
      expect(table_row).to have_content("Not applicable")
    end
  end

  optional_tasks.each do |task|
    scenario "a user can complete the actions on the optional task #{I18n.t("conversion.voluntary.tasks.#{task}.title")}" do
      click_on I18n.t("conversion.voluntary.tasks.#{task}.title")
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      # uncheck the Not applicable box
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.voluntary.tasks.#{task}.title"))
      expect(table_row).to have_content("Completed")
    end
  end
end
