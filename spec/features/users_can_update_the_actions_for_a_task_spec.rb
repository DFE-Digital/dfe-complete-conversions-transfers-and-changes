require "rails_helper"

RSpec.feature "Users can update the Actions for a Task" do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:completed_action) { create(:action, title: "Action 1", completed: true) }
  let(:incomplete_action) { create(:action, title: "Action 2") }
  let(:task) { create(:task, actions: [completed_action, incomplete_action]) }
  let(:project_id) { task.section.project.id }
  let(:task_id) { task.id }

  before do
    mock_successful_api_responses(urn: 12345, ukprn: 10061021)

    sign_in_with_user(user)
  end

  scenario "User updates a completed action and an incomplete action" do
    visit project_task_path(project_id, task_id)

    uncheck("Action 1")
    check("Action 2")

    click_button("Continue")

    expect(incomplete_action.reload.completed?).to be true
    expect(completed_action.reload.completed?).to be false

    expect(page).to have_current_path(project_path(project_id))
  end
end
