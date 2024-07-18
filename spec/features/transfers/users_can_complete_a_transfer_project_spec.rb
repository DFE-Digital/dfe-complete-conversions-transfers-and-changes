require "rails_helper"

RSpec.feature "Users can complete a transfer project" do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when the academy has transferred" do
    let(:tasks_data) {
      create(:transfer_tasks_data,
        declaration_of_expenditure_certificate_date_received: Date.today - 4.months,
        declaration_of_expenditure_certificate_correct: true,
        declaration_of_expenditure_certificate_saved: true,
        confirm_date_academy_transferred_date_transferred: Date.today - 3.months)
    }
    let(:project) {
      create(:transfer_project,
        assigned_to: user,
        significant_date: 2.months.ago.at_beginning_of_month,
        significant_date_provisional: false,
        authority_to_proceed: true,
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
    end
  end

  context "when the academy has not transferred" do
    let(:project) { create(:transfer_project, assigned_to: user) }

    scenario "the project cannot be completed" do
      visit project_path(project)

      click_on I18n.t("project.complete.submit_button")

      expect(page).to_not have_content("Project completed")
      expect(page).to have_content("This project cannot be completed")
      expect(project.reload.completed_at).to be_nil
    end
  end
end
