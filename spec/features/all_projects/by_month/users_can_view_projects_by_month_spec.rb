require "rails_helper"

RSpec.feature "Users can view projects by month" do
  context "a data user (who can export)" do
    let(:user) { create(:user, team: "education_and_skills_funding_agency") }

    scenario "the user sees the date range option in the By Month view" do
      sign_in_with_user(user)
      click_on "By month"
      expect(page).to have_content("Date range")
    end
  end

  context "any other user (who cannot export)" do
    let(:user) { create(:regional_casework_services_user) }

    scenario "the user sees a single month in the By Month view" do
      sign_in_with_user(user)

      click_on "All projects"
      click_on "By month"
      expect(page).to have_content((Date.today + 1.month).to_fs(:govuk_month))
      expect(page).to_not have_content("Date range")
    end
  end
end
