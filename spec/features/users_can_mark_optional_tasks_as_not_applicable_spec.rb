require "rails_helper"

RSpec.feature "Users can mark optional tasks as not applicable to a project" do
  let(:user_one) { create(:user, email: "user.one@education.gov.uk") }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 12345678)
    sign_in_with_user(user_one)
  end

  let(:project) { create(:project, urn: 123456, trust_ukprn: 12345678) }
  let!(:section) { create(:section, project: project) }
  let(:task) { create(:task, :not_applicable, title: "Not applicable task", section: section) }
  let!(:actions) { create_list(:action, 3, task: task, completed: true) }

  scenario "they can edit the task and see the status changed to 'not applicable'" do
    visit project_task_path(project, task)
    check "Not applicable"
    click_button "Continue"

    within("#not-applicable-task-status") do
      expect(page).to have_content(I18n.t("tasks.not_applicable"))
    end
  end
end
