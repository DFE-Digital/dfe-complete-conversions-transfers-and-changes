require "rails_helper"

RSpec.feature "Viewing completed projects" do
  let(:project) { create(:conversion_project, completed_at: Date.today - 3.months) }
  let(:user) { create(:user, :caseworker) }

  before do
    mock_successful_api_response_to_create_any_project
    sign_in_with_user(user)
  end

  scenario "users see a clear message indicating the project is completed" do
    visit conversions_voluntary_project_path(project)

    expect(page).to have_content("Project completed")
  end
end
