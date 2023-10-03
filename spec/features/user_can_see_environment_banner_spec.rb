require "rails_helper"

RSpec.feature "Environment banner" do
  before do
    user = create(:user)
    sign_in_with_user(user)
  end

  describe "environment banner" do
    scenario "when the USER_ENV is production cannot see the environment banner" do
      ClimateControl.modify(
        USER_ENV: "production"
      ) do
        visit root_path

        expect(page).to_not have_css("#environment-banner")
      end
    end
  end

  scenario "when the USER_ENV is development can see the environment banner" do
    ClimateControl.modify(
      USER_ENV: "development"
    ) do
      visit root_path
      within("#environment-banner") do
        expect(page).to have_content("DEVELOPMENT ENVIRONMENT")
      end
    end
  end
end
