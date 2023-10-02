require "rails_helper"

RSpec.feature "The home page for a regional casework services user" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
  end

  scenario "redirects to the your projects view" do
    visit root_path

    expect(page.current_path).to eql in_progress_your_projects_path
  end

  scenario "shows the added by you primary navigation" do
    visit root_path

    expect(page).to have_link "Added by you"
  end
end
