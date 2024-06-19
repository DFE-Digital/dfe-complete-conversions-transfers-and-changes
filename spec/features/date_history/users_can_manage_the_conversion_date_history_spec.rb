require "rails_helper"

RSpec.feature "Users can manage the conversion date history" do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "they can create a new earlier date" do
    original_date = Date.today.at_beginning_of_month
    revised_date = original_date - 1.month
    project = create(
      :conversion_project,
      conversion_date: original_date,
      conversion_date_provisional: false,
      assigned_to: user
    )

    visit project_path(project)
    click_on "Change conversion date"
    fill_in "Month", with: revised_date.month.to_s
    fill_in "Year", with: revised_date.year.to_s
    click_on "Save and continue"

    expect(page).to have_content "The new proposed conversion date is"
    expect(page).to have_content revised_date.to_fs(:govuk)

    check "Correcting an error"
    within "#correcting_an_error_note" do
      fill_in "Enter details about the reason for the change.", with: "I made a mistake when setting the new date."
    end
    click_on "Save and continue"

    expect(page).to have_content "Conversion date changed"

    click_on "continue working on this conversion"
    click_on "Conversion date history"

    within ".govuk-summary-card:first-of-type" do
      expect(page).to have_content "Correcting an error"
      expect(page).to have_content "I made a mistake when setting the new date."
    end
  end

  scenario "they can create a new later date" do
    original_date = Date.today.at_beginning_of_month
    revised_date = original_date + 1.month
    project = create(
      :conversion_project,
      conversion_date: original_date,
      conversion_date_provisional: false,
      assigned_to: user
    )

    visit project_path(project)
    click_on "Change conversion date"
    fill_in "Month", with: revised_date.month.to_s
    fill_in "Year", with: revised_date.year.to_s
    click_on "Save and continue"

    expect(page).to have_content "The new proposed conversion date is"
    expect(page).to have_content revised_date.to_fs(:govuk)

    check "School"
    within "#school_note" do
      fill_in "Enter details about the reason for the change.", with: "The school needs more time."
    end
    click_on "Save and continue"

    expect(page).to have_content "Conversion date changed"

    click_on "continue working on this conversion"
    click_on "Conversion date history"

    within ".govuk-summary-card:first-of-type" do
      expect(page).to have_content "School"
      expect(page).to have_content "The school needs more time."
    end
  end
end
