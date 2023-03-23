require "rails_helper"

RSpec.feature "The home page for a regional casework services user" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
  end

  scenario "contains the regional casework services in-progress projects" do
    visit root_path
    click_on "In progress"

    expect(page.current_path).to eql in_progress_user_projects_path
  end

  scenario "contains the regional casework services completed projects" do
    visit root_path
    click_on "Completed"

    expect(page.current_path).to eql completed_user_projects_path
  end

  scenario "does not show the unassigned tab" do
    visit root_path

    expect(page).not_to have_content("Unassigned")
  end
end
