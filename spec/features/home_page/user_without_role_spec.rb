require "rails_helper"

RSpec.feature "The home page for a user without a role" do
  before do
    user = create(:user)
    sign_in_with_user(user)
  end

  scenario "redirects to the all project in progress view" do
    visit root_path
    click_on "In progress"

    expect(page.current_path).to eql all_all_in_progress_projects_path
  end
end
