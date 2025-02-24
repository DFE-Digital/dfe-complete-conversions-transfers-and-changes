require "rails_helper"

RSpec.feature "Users can complete a conversion project" do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when all conditions have been met and the academy has opened" do
    let(:tasks_data) {
      create(:conversion_tasks_data,
        receive_grant_payment_certificate_check_certificate: true,
        receive_grant_payment_certificate_save_certificate: true,
        receive_grant_payment_certificate_date_received: Date.today,
        confirm_date_academy_opened_date_opened: Date.today)
    }
    let(:project) {
      create(:conversion_project,
        assigned_to: user,
        conversion_date: 2.months.ago.at_beginning_of_month,
        conversion_date_provisional: false,
        all_conditions_met: true,
        tasks_data: tasks_data)
    }

    scenario "the project is completed successfully" do
      visit project_path(project)

      click_on "Completing a project"

      click_on I18n.t("project.complete.submit_button")

      expect(page).to have_content("Project completed")
      expect(page).to have_content("You have completed the project for #{project.establishment.name} #{project.urn}.")
      expect(project.reload.completed_at).not_to be_nil

      expect(page).to have_link "short survey", href: "https://forms.office.com/e/xf0k4LcWVN"

      click_on I18n.t("project.complete.back_link")
      # The project listing is no longer on the index page (open projects only)
      expect(page).to_not have_content(project.establishment.name)

      # The project has moved to the Completed tab
      click_on I18n.t("subnavigation.completed_projects")
      click_on project.establishment.name

      expect(page).to have_content(DateTime.now.to_formatted_s(:govuk_date_time_date_only))
    end
  end

  context "when the project does not have all conditions met and the academy has not opened" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    scenario "the project cannot be completed" do
      visit project_path(project)

      click_on I18n.t("project.complete.submit_button")

      expect(page).to_not have_content("Project completed")
      expect(page).to have_content("This project cannot be completed")

      expect(page).to have_content("The conversion date has been confirmed and is in the past")
      expect(page).to have_content("The confirm all conditions have been met task is completed")
      expect(page).to have_content("The confirm the date the academy opened task is completed")
      expect(page).to have_content("receive declaration of expenditure certificate task")

      expect(project.reload.completed_at).to be_nil
    end
  end
end
