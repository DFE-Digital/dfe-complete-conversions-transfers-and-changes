require "rails_helper"

RSpec.feature "Users can view the Actions for a Task" do
  let(:user_1) { create(:user, email: "user1@education.gov.uk") }
  let(:action) { create(:action) }
  let(:task_id) { action.task.id }
  let(:project_id) { action.task.section.project.id }

  before do
    mock_successful_api_responses(urn: 12345)

    sign_in_with_user(user_1)
  end

  scenario "User views the list of tasks" do
    visit project_task_path(project_id, task_id)

    expect(page).to have_content("Clear land questionnaire")
    expect(page).to have_content("Have you received the land questionnaire?")
  end
end
