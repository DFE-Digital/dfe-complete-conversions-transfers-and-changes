require "rails_helper"

RSpec.feature "Track authenticated user using AppInsights" do
  context "when the user is logged in" do
    before do
      user = create(:user, email: "test@education.gov.uk")
      sign_in_with_user(user)
    end
    scenario "the DOM includes the user's email address for AppInsights" do
      visit cookies_path

      user_id = find("#current-user", visible: false)["data-identifier"]
      expect(user_id).to eq("test@education.gov.uk")
    end
  end

  context "when the user is NOT logged in" do
    scenario "the DOM includes the magic string 'Anonymous' for AppInsights" do
      visit cookies_path

      user_id = find("#current-user", visible: false)["data-identifier"]
      expect(user_id).to eq("Anonymous")
    end
  end
end
