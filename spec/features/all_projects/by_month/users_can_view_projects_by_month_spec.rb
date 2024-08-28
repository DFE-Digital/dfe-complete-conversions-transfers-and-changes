require "rails_helper"

RSpec.feature "Users can view projects by month" do
  context "a data user (who can export)" do
    let(:user) { create(:user, team: "data_consumers") }

    scenario "the user sees the date range option in the By Month view" do
      sign_in_with_user(user)
      click_on "By month"
      expect(page).to have_content("Date range")
    end

    scenario "the user can download a CSV of conversion projects" do
      sign_in_with_user(user)
      click_on "By month"
      click_on "Conversions"

      select "Jan 2023", from: "from"
      select "Dec 2023", from: "to"
      click_on "Apply"

      click_on "download a more detailed version of the data as a CSV file"
      expect(page.response_headers["Content-Disposition"]).to include("2023-01-01-2023-12-31_schools_due_to_convert.csv")
    end

    scenario "the user can download a CSV of transfer projects" do
      sign_in_with_user(user)
      click_on "By month"
      click_on "Transfers"

      select "Jan 2023", from: "from"
      select "Dec 2023", from: "to"
      click_on "Apply"

      click_on "download a more detailed version of the data as a CSV file"
      expect(page.response_headers["Content-Disposition"]).to include("2023-01-01-2023-12-31_academies_due_to_transfer.csv")
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

    scenario "the user can download a CSV of conversion projects" do
      sign_in_with_user(user)
      click_on "All projects"
      click_on "By month"
      click_on "Conversions"

      click_on "download a more detailed version of the data as a CSV file"
      expect(page.response_headers["Content-Disposition"]).to include("#{(Date.today + 1.month).month}-#{Date.today.year}_schools_due_to_convert.csv")
    end

    scenario "the user can download a CSV of transfer projects" do
      sign_in_with_user(user)
      click_on "All projects"
      click_on "By month"
      click_on "Transfers"

      click_on "download a more detailed version of the data as a CSV file"
      expect(page.response_headers["Content-Disposition"]).to include("#{(Date.today + 1.month).month}-#{Date.today.year}_academies_due_to_transfer.csv")
    end
  end
end
