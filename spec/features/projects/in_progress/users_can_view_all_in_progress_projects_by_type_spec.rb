require "rails_helper"

RSpec.feature "Users can view all in progress projects by type" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let!(:conversion_project) { create(:conversion_project, urn: 123456) }
  let!(:transfer_project) { create(:transfer_project, urn: 165432) }

  scenario "view all projects in a table" do
    visit all_all_in_progress_projects_path

    expect(page).to have_content conversion_project.urn
    expect(page).to have_content transfer_project.urn
  end

  scenario "view all conversion projects in a table" do
    visit all_all_in_progress_projects_path

    click_on "Conversions"

    expect(page).to have_content conversion_project.urn
    expect(page).not_to have_content transfer_project.urn
  end

  scenario "view all transfer projects in a table" do
    visit all_all_in_progress_projects_path

    click_on "Transfers"

    expect(page).to have_content transfer_project.urn
    expect(page).not_to have_content conversion_project.urn
  end
end
