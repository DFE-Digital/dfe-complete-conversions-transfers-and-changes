require "rails_helper"

RSpec.feature "Users can view project groups" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "they can view all groups" do
    click_on "Groups"

    expect(page).to have_content "Groups"
  end
end
