require "rails_helper"

RSpec.feature "Data users can view projects over a range of dates" do
  let(:user) { create(:user, team: "education_and_skills_funding_agency") }

  scenario "A data user sees the current month by default" do
    sign_in_with_user(user)
    visit "/projects/all/by-month/conversions/from/to"

    expect(page).to have_content("Academies opening or transferring")
    expect(page).to have_content("#{Date.today.to_fs(:govuk_month)} to #{Date.today.to_fs(:govuk_month)}")
  end

  scenario "A data user can choose a range of different dates to view" do
    sign_in_with_user(user)
    visit "/projects/all/by-month/conversions/from/to"

    select "Jan 2023", from: "from"
    select "Aug 2023", from: "to"
    click_on "Apply"

    expect(page).to have_content("Academies opening or transferring")
    expect(page).to have_content("January 2023 to August 2023")
  end
end
