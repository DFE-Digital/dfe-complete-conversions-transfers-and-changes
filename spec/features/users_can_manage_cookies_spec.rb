require "rails_helper"

RSpec.feature "Users can manage cookies" do
  context "when a user is not signed in" do
    scenario "they can view the cookies details" do
      visit cookies_path

      expect(page).to have_content("Essential cookies")
    end
  end
end
