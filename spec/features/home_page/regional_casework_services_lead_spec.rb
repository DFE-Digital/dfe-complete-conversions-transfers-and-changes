require "rails_helper"

RSpec.feature "The home page for a team lead" do
  before do
    user = create(:user, :team_leader)
    sign_in_with_user(user)
  end

  scenario "contains the unassigned projects" do
    visit root_path

    expect(page.current_path).to eql unassigned_team_projects_path
  end

  scenario "contains the regional casework services in-progress projects" do
    visit root_path
    click_on "In progress"

    expect(page.current_path).to eql in_progress_team_projects_path
  end

  scenario "contains the regional casework services completed projects" do
    visit root_path
    click_on "Completed"

    expect(page.current_path).to eql completed_team_projects_path
  end
end
