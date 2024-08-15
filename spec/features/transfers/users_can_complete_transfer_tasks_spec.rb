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
    rpa_policy
    supplemental_funding_agreement
    confirm_incoming_trust_has_completed_all_actions
    redact_and_send_documents
  ]

  optional_tasks = %w[
    handover
    deed_of_variation
    articles_of_association
    land_consent_letter
    form_m
    church_supplemental_agreement
    deed_termination_church_agreement
    master_funding_agreement
    deed_of_termination_for_the_master_funding_agreement
    closure_or_transfer_declaration
    request_new_urn_and_record
  ]

  tasks_with_collected_data = %w[
    stakeholder_kick_off
    conditions_met
    confirm_headteacher_contact
    confirm_incoming_trust_ceo_contact
    confirm_outgoing_trust_ceo_contact
    main_contact
    bank_details_changing
    check_and_confirm_financial_information
    confirm_date_academy_transferred
    sponsored_grant_type
    declaration_of_expenditure_certificate
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

  describe "tasks with collected data" do
    describe "the sponsored support grant task" do
      before do
        visit project_tasks_path(project)
        click_on "Confirm transfer grant funding level"
      end

      scenario "the response can be standard" do
        choose "Standard transfer grant"
        click_on I18n.t("task_list.continue_button.text")

        expect(project.reload.tasks_data.sponsored_support_grant_type).to eq "standard"
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

        table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.sponsored_support_grant.title"))
        expect(table_row).to have_content("Completed")
      end

      scenario "the task can be marked as Not applicable" do
        page.find(".govuk-checkboxes__label", text: "Not applicable").click
        click_on I18n.t("task_list.continue_button.text")

        table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.sponsored_support_grant.title"))
        expect(table_row).to have_content("Not applicable")
      end
    end

    describe "the check_and_confirm_financial_information task" do
      before do
        visit project_tasks_path(project)
        click_on "Check and confirm academy and trust financial information"
      end

      it "can collect surplus for academy and trust finances" do
        within_fieldset("Is the academy in surplus or deficit?") do
          choose "Surplus"
        end

        within_fieldset("Is the incoming trust in surplus or deficit?") do
          choose "Surplus"
        end

        click_on I18n.t("task_list.continue_button.text")

        expect(project.reload.tasks_data.check_and_confirm_financial_information_academy_surplus_deficit).to eq "surplus"
        expect(project.reload.tasks_data.check_and_confirm_financial_information_trust_surplus_deficit).to eq "surplus"
      end

      it "can collect deficit for academy and trust finances" do
        within_fieldset("Is the academy in surplus or deficit?") do
          choose "Deficit"
        end

        within_fieldset("Is the incoming trust in surplus or deficit?") do
          choose "Deficit"
        end

        click_on I18n.t("task_list.continue_button.text")

        expect(project.reload.tasks_data.check_and_confirm_financial_information_academy_surplus_deficit).to eq "deficit"
        expect(project.reload.tasks_data.check_and_confirm_financial_information_trust_surplus_deficit).to eq "deficit"
      end

      it "can be not applicable" do
        click_not_applicable(page)
        click_on I18n.t("task_list.continue_button.text")
        expect(project.reload.tasks_data.check_and_confirm_financial_information_not_applicable).to be true
      end

      it "can be completed" do
        within_fieldset("Is the academy in surplus or deficit?") do
          choose "Surplus"
        end

        within_fieldset("Is the incoming trust in surplus or deficit?") do
          choose "Deficit"
        end

        click_on I18n.t("task_list.continue_button.text")
        table_row = page.find("li.app-task-list__item", text: I18n.t("transfer.task.check_and_confirm_financial_information.title"))

        expect(table_row).to have_content("Completed")
      end
    end
  end

  describe "the confirm date academy transferred task" do
    let(:project) { create(:transfer_project, assigned_to: user) }

    context "when the task does not have a date" do
      scenario "they can add a date" do
        visit project_tasks_path(project)
        click_on "Confirm the date the academy transferred"
        fill_in "Day", with: "1"
        fill_in "Month", with: "1"
        fill_in "Year", with: "2024"
        click_on I18n.t("task_list.continue_button.text")

        expect(project.reload.tasks_data.confirm_date_academy_transferred_date_transferred).to eq Date.new(2024, 1, 1)
      end
    end

    describe "the declaration of expenditure certificate task" do
      scenario "can be completed" do
        visit project_tasks_path(project)
        click_on "Receive declaration of expenditure certificate"
        check "Check the declaration of expenditure certificate is correct"
        check "Save the declaration of expenditure certificate in the academy's SharePoint folder"
        fill_in "Day", with: "1"
        fill_in "Month", with: "1"
        fill_in "Year", with: "2024"
        click_on I18n.t("task_list.continue_button.text")

        table_row = page.find("li.app-task-list__item", text: "Receive declaration of expenditure certificate")
        expect(table_row).to have_content("Complete")
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
