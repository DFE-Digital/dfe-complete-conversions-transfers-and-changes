require "rails_helper"

RSpec.feature "Users can complete a project" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "successfully" do
    visit project_path(project)

    click_on I18n.t("project.complete.submit_button")

    expect(page).to have_content("Project completed")
    expect(project.reload.completed_at).not_to be_nil

    click_on I18n.t("project.complete.back_link")
    click_on project.establishment.name

    expect(page).to have_content(DateTime.now.to_formatted_s(:govuk_date_time_date_only))
  end
end
