require "rails_helper"

RSpec.feature "Users can close a project" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "successfully" do
    visit project_path(project)

    click_on I18n.t("project.close.submit_button")

    expect(page).to have_content("Project closed")
    expect(project.reload.closed_at).not_to be_nil
  end
end
