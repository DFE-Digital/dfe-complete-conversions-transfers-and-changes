require "rails_helper"

RSpec.feature "Users can export funding agreement lettes data" do
  before do
    user = create(:user)
    sign_in_with(user)
  end

  scenario "they can view the data for last month" do
    mock_all_academies_api_responses
    last_month = Date.today.last_month.at_beginning_of_month
    create(:conversion_project, conversion_date: last_month, conversion_date_provisional: false)

    visit "/projects/all/export/funding-agreement-letters/conversions/"

    expect(page).to have_content(last_month.to_fs(:govuk_month))
    expect(page).to have_link("Export")
  end

  scenario "they can view the data for this month" do
    mock_all_academies_api_responses
    this_month = Date.today.at_beginning_of_month
    create(:conversion_project, conversion_date: this_month, conversion_date_provisional: false)

    visit "/projects/all/export/funding-agreement-letters/conversions/"

    expect(page).to have_content(this_month.to_fs(:govuk_month))
    expect(page).to have_link("Export")
  end

  scenario "they can view the data for four months ahead" do
    mock_all_academies_api_responses
    four_months_time = (Date.today + 4.months).at_beginning_of_month
    create(:conversion_project, conversion_date: four_months_time, conversion_date_provisional: false)

    visit "/projects/all/export/funding-agreement-letters/conversions/"

    expect(page).to have_content(four_months_time.to_fs(:govuk_month))
    expect(page).to have_link("Export")
  end

  scenario "they can link to the data export" do
    mock_all_academies_api_responses
    this_month = Date.today.at_beginning_of_month
    create(:conversion_project, conversion_date: this_month, conversion_date_provisional: false)

    visit "/projects/all/export/funding-agreement-letters/conversions/#{this_month.month}/#{this_month.year}"

    expect(page).to have_content(this_month.to_fs(:govuk_month))
    expect(page).to have_link("Download", href: "/projects/all/export/funding-agreement-letters/conversions/#{this_month.month}/#{this_month.year}/csv")
  end
end
