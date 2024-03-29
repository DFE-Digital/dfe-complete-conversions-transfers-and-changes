require "rails_helper"

RSpec.feature "Viewing another user's or unassigned project" do
  let(:user) { create(:user, :caseworker) }
  let(:other_user) { create(:user, :caseworker, email: "other.user@education.gov.uk") }
  let(:project) { create(:conversion_project, assigned_to: other_user) }

  before do
    mock_successful_api_response_to_create_any_project
    sign_in_with_user(user)
  end

  scenario "they see a clear message indicating the project is not assigned to them" do
    visit project_path(project)

    expect(page).to have_content("Not assigned to project")
  end

  scenario "users do not see the complete project button" do
    visit project_path(project)

    expect(page).not_to have_button("Complete project")
  end

  scenario "users do not see the submit button on tasks" do
    task_list = Conversion::TaskList.new(project, user)
    task = task_list.tasks.first
    visit project_edit_task_path(project, task.class.identifier)

    expect(page).not_to have_button("Save and return")
  end
end
