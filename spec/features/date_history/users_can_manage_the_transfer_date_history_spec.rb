require "rails_helper"

RSpec.feature "Users can manage the transfer date history" do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "they can create a new earlier date" do
    original_date = Date.today.at_beginning_of_month
    revised_date = original_date - 1.month
    project = create(
      :transfer_project,
      transfer_date: original_date,
      transfer_date_provisional: false,
      assigned_to: user
    )

    visit project_path(project)
    click_on "Change transfer date"
    fill_in "Month", with: revised_date.month.to_s
    fill_in "Year", with: revised_date.year.to_s
    click_on "Save and continue"

    expect(page).to have_content "The new proposed transfer date is"
    expect(page).to have_content revised_date.to_fs(:govuk)

    check "Correcting an error"
    within "#correcting_an_error_note" do
      fill_in "Enter details about the reason for the change.", with: "I made a mistake when setting the new date."
    end
    click_on "Save and continue"

    expect(page).to have_content "Transfer date changed"

    click_on "continue working on this transfer"
    click_on "Transfer date history"

    within ".govuk-summary-card:first-of-type" do
      expect(page).to have_content "Correcting an error"
      expect(page).to have_content "I made a mistake when setting the new date."
    end
  end

  scenario "they can create a new later date" do
    original_date = Date.today.at_beginning_of_month
    revised_date = original_date + 1.month
    project = create(
      :transfer_project,
      transfer_date: original_date,
      transfer_date_provisional: false,
      assigned_to: user
    )

    visit project_path(project)
    click_on "Change transfer date"
    fill_in "Month", with: revised_date.month.to_s
    fill_in "Year", with: revised_date.year.to_s
    click_on "Save and continue"

    expect(page).to have_content "The new proposed transfer date is"
    expect(page).to have_content revised_date.to_fs(:govuk)

    check "Academy"
    within "#academy_note" do
      fill_in "Enter details about the reason for the change.", with: "The academy needs more time."
    end
    click_on "Save and continue"

    expect(page).to have_content "Transfer date changed"

    click_on "continue working on this transfer"
    click_on "Transfer date history"

    within ".govuk-summary-card:first-of-type" do
      expect(page).to have_content "Academy"
      expect(page).to have_content "The academy needs more time."
    end
  end
end
