require "rails_helper"

RSpec.feature "Users can complete a transfer project" do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when the academy has transferred" do
    let(:project) {
      create(:transfer_project,
        assigned_to: user,
        significant_date: 2.months.ago.at_beginning_of_month,
        significant_date_provisional: false)
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
