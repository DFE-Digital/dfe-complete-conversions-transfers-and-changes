require "rails_helper"
require "axe-rspec"

RSpec.feature "Test tasks accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "show tasks page" do
    section = create(:section, project: project)
    task = create(:task, section: section)

    visit project_path(project)

    expect(page).to have_content(task.title)
    expect(page).to be_axe_clean
  end

  scenario "individual task page" do
    section = create(:section, project: project)
    task = create(:task, section: section)

    visit project_task_path(project, task)

    expect(page).to have_content(task.title)
    expect(page).to be_axe_clean
  end
end
