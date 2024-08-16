require "rails_helper"

RSpec.feature "Users can complete conversion tasks" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:project) { create(:conversion_project, assigned_to: user) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
    visit project_tasks_path(project)
  end

  mandatory_tasks = %w[
    check_accuracy_of_higher_needs
    commercial_transfer_agreement
    land_questionnaire land_registry
    redact_and_send
    school_completed share_information single_worksheet
    supplemental_funding_agreement
  ]

  optional_tasks = %w[handover articles_of_association church_supplemental_agreement
    complete_notification_of_change deed_of_variation direction_to_transfer master_funding_agreement
    one_hundred_and_twenty_five_year_lease subleases tenancy_at_will
    trust_modification_order conversion_grant]

  tasks_with_collected_data = %w[
    stakeholder_kick_off
    academy_details
    risk_protection_arrangement
    sponsored_support_grant
    conditions_met
    confirm_headteacher_contact
    confirm_chair_of_governors_contact
    main_contact
    proposed_capacity_of_the_academy
    receive_grant_payment_certificate
    confirm_date_academy_opened
  ]

  it "confirms we are checking all tasks" do
    # If this test fails, we have added or removed a task from the page
    # and need to add or remove it from the arrays above
    tasks_we_are_testing = mandatory_tasks.count + optional_tasks.count + tasks_with_collected_data.count
    tasks_on_page = page.find_all("ol.app-task-list ul li a").count
    expect(tasks_on_page).to eq tasks_we_are_testing
  end

  describe "the stakeholder kick-off task" do
    context "when the project conversion date is provisional" do
      let(:project) { create(:conversion_project, assigned_to: user, conversion_date_provisional: true) }

      scenario "they can set the confirmed date" do
        visit project_tasks_path(project)

        click_on "External stakeholder kick-off"
        page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
        completion_date = Date.today + 1.year
        fill_in "Month", with: completion_date.month
        fill_in "Year", with: completion_date.year
        click_on I18n.t("task_list.continue_button.text")
        table_row = page.find("li.app-task-list__item", text: "External stakeholder kick-off")
        expect(table_row).to have_content("Completed")
      end
    end

    context "when the project conversion date is confirmed" do
      let(:project) { create(:conversion_project, assigned_to: user, conversion_date_provisional: false) }

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

  describe "the academy details task" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    scenario "they can not provide a value" do
      visit project_tasks_path(project)
      click_on "Confirm the academy name"
      click_on I18n.t("task_list.continue_button.text")

      expect(page).to have_current_path(project_tasks_path(project))
    end

    scenario "they can provide a value" do
      visit project_tasks_path(project)
      click_on "Confirm the academy name"
      fill_in "Enter the academy name", with: "Test academy name"
      click_on I18n.t("task_list.continue_button.text")

      expect(project.tasks_data.reload.academy_details_name).to eql "Test academy name"
    end
  end

  context "when the project has a confirmed conversion date" do
    let(:project) { create(:conversion_project, conversion_date: Date.new(2024, 1, 1)) }

    scenario "the Conditions met task shows the confirmed conversion date in the hint text" do
      click_on "Confirm all conditions have been met"
      expect(page).to have_content("All conditions must be met before the deadline or the school will not be able to convert on 1 January 2024")
    end
  end

  context "when the project does not have a confirmed conversion date" do
    let(:project) { create(:conversion_project, conversion_date: Date.new(2023, 12, 1), conversion_date_provisional: true) }

    scenario "the Conditions met task shows the provisional conversion date in the hint text" do
      click_on "Confirm all conditions have been met"
      expect(page).to have_content("All conditions must be met before the deadline or the school will not be able to convert on 1 December 2023")
    end
  end

  context "the main contact task" do
    let(:project) { create(:conversion_project, assigned_to: user) }

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

        expect(page).to have_content("Add a contact")
        click_link "add a contact"
        expect(page.current_path).to include("external-contacts")
      end
    end
  end

  describe "the risk protection arrangement task" do
    before do
      visit project_tasks_path(project)
      click_on "Confirm the academy's risk protection arrangements"
    end

    scenario "the response can be stanard" do
      choose "Yes, joining standard RPA"
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.tasks_data.risk_protection_arrangement_option).to eq "standard"
    end

    scenario "the response can be church or trust" do
      choose "Yes, joining church or trust RPA"
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.tasks_data.risk_protection_arrangement_option).to eq "church_or_trust"
    end

    scenario "the response can be commercial" do
      choose "No, buying commercial insurance"
      fill_in "Why has the academy chosen commercial insurance?", with: "This is the reason."
      expect(page).to have_content("insurance no later than 11.59pm")

      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.tasks_data.risk_protection_arrangement_option).to eq "commercial"
      expect(project.reload.tasks_data.risk_protection_arrangement_reason).to eq "This is the reason."
    end

    scenario "the response can be blank" do
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.tasks_data.risk_protection_arrangement_option).to be_nil
    end
  end

  describe "the sponsored support grant task" do
    before do
      visit project_tasks_path(project)
      click_on "Confirm and process the sponsored support grant"
    end

    scenario "the response can be fast track" do
      choose "Fast track"
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.tasks_data.sponsored_support_grant_type).to eq "fast_track"
    end

    scenario "the response can be intermediate" do
      choose "Intermediate"
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.tasks_data.sponsored_support_grant_type).to eq "intermediate"
    end

    scenario "the response can be full sponsored" do
      choose "Full sponsored"
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.tasks_data.sponsored_support_grant_type).to eq "full_sponsored"
    end

    scenario "the task can be completed" do
      choose "Full sponsored"
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      # uncheck the Not applicable box
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")

      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.task.sponsored_support_grant.title"))
      expect(table_row).to have_content("Completed")
    end

    scenario "the task can be marked as Not applicable" do
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")

      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.task.sponsored_support_grant.title"))
      expect(table_row).to have_content("Not applicable")
    end
  end

  describe "the confirm all conditions met task" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    scenario "they can confirm all conditions have been met" do
      visit project_tasks_path(project)
      click_on "Confirm all conditions have been met"
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      click_on I18n.t("task_list.continue_button.text")

      expect(project.reload.all_conditions_met).to be true
    end
  end

  describe "the receive grant payment certificate task" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    context "when the task does not have a date" do
      scenario "they can add a date" do
        visit project_tasks_path(project)
        click_on "Receive declaration of expenditure certificate"
        page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
        fill_in "Day", with: "1"
        fill_in "Month", with: "1"
        fill_in "Year", with: "2024"
        click_on I18n.t("task_list.continue_button.text")

        expect(project.reload.tasks_data.receive_grant_payment_certificate_date_received).to eq Date.new(2024, 1, 1)
      end
    end

    context "when the task has a date" do
      let(:tasks_data) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: Date.new(2024, 1, 1)) }
      let(:project) { create(:conversion_project, assigned_to: user, tasks_data: tasks_data) }

      scenario "they see the date on the page but cannot add a new one" do
        visit project_tasks_path(project)
        click_on "Receive declaration of expenditure certificate"
        expect(page).to have_content("DfE received the declaration of expenditure certificate on 1 January 2024.")
        expect(page).to_not have_content("Enter the date you received the declaration of expenditure certificate")
      end
    end
  end

  describe "the update ESFA task" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    scenario "they can compelte the task" do
      skip("task is disabled for now")
      visit project_tasks_path(project)
      click_on "Add notes for ESFA"

      click_on "Add a new task note"
      fill_in "Enter note", with: "These are my handover notes for the ESFA"
      click_on "Add note"

      check "Add notes to this task"
      click_on "Save and return"

      task_status = find("#add-notes-for-esfa-status")
      expect(task_status).to have_content("Completed")
    end
  end

  describe "the confirm date academy opened task" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    context "when the task does not have a date" do
      scenario "they can add a date" do
        visit project_tasks_path(project)
        click_on "Confirm the date the academy opened"
        fill_in "Day", with: "1"
        fill_in "Month", with: "1"
        fill_in "Year", with: "2024"
        click_on I18n.t("task_list.continue_button.text")

        expect(project.reload.tasks_data.confirm_date_academy_opened_date_opened).to eq Date.new(2024, 1, 1)
      end
    end
  end

  mandatory_tasks.each do |task|
    scenario "a user can complete the actions on the mandatory #{I18n.t("conversion.task.#{task}.title")} task" do
      click_on I18n.t("conversion.task.#{task}.title")
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.task.#{task}.title"))
      expect(table_row).to have_content("Completed")
    end
  end

  optional_tasks.each do |task|
    scenario "a user can mark an optional task #{I18n.t("conversion.task.#{task}.title")} as not applicable" do
      click_on I18n.t("conversion.task.#{task}.title")
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.task.#{task}.title"))
      expect(table_row).to have_content("Not applicable")
    end
  end

  optional_tasks.each do |task|
    scenario "a user can complete the actions on the optional task #{I18n.t("conversion.task.#{task}.title")}" do
      click_on I18n.t("conversion.task.#{task}.title")
      page.find_all(".govuk-checkboxes__input").each { |checkbox| checkbox.click }
      # uncheck the Not applicable box
      page.find(".govuk-checkboxes__label", text: "Not applicable").click
      click_on I18n.t("task_list.continue_button.text")
      table_row = page.find("li.app-task-list__item", text: I18n.t("conversion.task.#{task}.title"))
      expect(table_row).to have_content("Completed")
    end
  end
end
