require "rails_helper"

RSpec.feature "Pre conversion grants" do
  before do
    user = create(:user, :service_support)
    sign_in_with_user(user)
    mock_all_academies_api_responses
    create(:conversion_project, conversion_date: Date.new(2024, 6, 1))
  end

  scenario "users can export the data" do
    click_on "All projects"
    click_on "Exports"
    click_on "pre-opening grants for schools becoming academies"

    select "Jan 2024", from: "from"
    select "Dec 2024", from: "to"

    expect(page).to have_button "Download CSV file"
  end
end
