require "rails_helper"

RSpec.feature "Users can view a voluntary conversion task list" do
  let(:user) { create(:user) }
  let(:project) { create(:conversion_project) }
  let(:project_id) { project.id }

  before do
    sign_in_with_user(user)

    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  scenario "can see the task list" do
    visit conversions_voluntary_project_path(project)

    expect(page).to have_content("Task list")
  end
end
