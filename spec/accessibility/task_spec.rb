require "rails_helper"
require "axe-rspec"

RSpec.feature "Test tasks accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:project) { create(:conversion_project, caseworker: user) }
  let(:task_identifier) { "handover" }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "show tasks page" do
    visit project_path(project)

    expect(page).to have_content(I18n.t("conversion.task.#{task_identifier}.title"))
    check_accessibility(page)
  end

  scenario "individual task page" do
    visit project_edit_task_path(project, task_identifier)

    expect(page).to have_content(I18n.t("conversion.task.#{task_identifier}.title"))
    check_accessibility(page)
  end
end
