require "rails_helper"

RSpec.feature "Viewing completed projects" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, completed_at: Date.today - 3.months, assigned_to: user) }

  before do
    mock_successful_api_response_to_create_any_project
    sign_in_with_user(user)
  end

  scenario "users see a clear message indicating the project is completed" do
    visit project_path(project)

    expect(page).to have_content("Project completed")
  end

  scenario "users do not see the complete project button" do
    visit project_path(project)

    expect(page).not_to have_button("Complete project")
  end

  scenario "users do not see the submit button on tasks" do
    task_list = Conversion::TaskList.new(project, user)
    task_list.tasks.each do |task|
      visit project_edit_task_path(project, task.class.identifier)

      expect(page).not_to have_button("Save and return")
    end
  end
end
