require "rails_helper"

RSpec.feature "Users record the revocation of a DAO from a project" do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "by providing all of the details correctly" do
    project = create(:conversion_project, directive_academy_order: true, assigned_to: user)

    visit project_path(project)

    click_on "Revoke a Directive Academy Order"

    click_on "Record DAO revocation"

    expect(page).to have_content "Record Directive Academy Order revocation"

    click_on "Continue"

    check "I confirm a minister has approved this decision"
    check "I confirm I have sent the letter confirming the revocation decision"
    check "I confirm I have saved a copy of the letter to the school’s SharePoint folder"
    click_button "Continue"

    expect(page).to have_content "Why was the DAO revoked?"

    check "School closed or closing"
    check "Safeguarding concerns addressed"
    click_button "Continue"

    expect(page).to have_content "Minister’s name"
    fill_in "Minister’s name", with: "Ministers Name"
    click_button "Continue"

    expect(page).to have_content "Date of decision"
    fill_in "Day", with: 1
    fill_in "Month", with: 1
    fill_in "Year", with: 2024
    click_button "Continue"

    expect(page).to have_content "Check your answers before recording this decision"
    click_button "Record DAO revocation"

    expect(page).to have_content "DAO revocation recorded successfully"
  end

  scenario "they can change details before submitting" do
    project = create(:conversion_project, directive_academy_order: true, assigned_to: user)

    visit project_path(project)

    click_on "Revoke a Directive Academy Order"

    click_on "Record DAO revocation"

    expect(page).to have_content "Record Directive Academy Order revocation"

    click_on "Continue"

    check "I confirm a minister has approved this decision"
    check "I confirm I have sent the letter confirming the revocation decision"
    check "I confirm I have saved a copy of the letter to the school’s SharePoint folder"
    click_button "Continue"

    expect(page).to have_content "Why was the DAO revoked?"

    check "School closed or closing"
    check "Safeguarding concerns addressed"
    click_button "Continue"

    expect(page).to have_content "Minister’s name"
    fill_in "Minister’s name", with: "Incorrect Name"
    click_button "Continue"

    expect(page).to have_content "Date of decision"
    fill_in "Day", with: 1
    fill_in "Month", with: 1
    fill_in "Year", with: 2024
    click_button "Continue"

    expect(page).to have_content "Check your answers before recording this decision"

    within ".govuk-summary-list__row:nth-of-type(4)" do
      click_on "Change"
    end

    expect(page).to have_content "Minister’s name"
    fill_in "Minister’s name", with: "Minister Name"
    click_button "Continue"

    expect(page).to have_content "Check your answers before recording this decision"

    within ".govuk-summary-list__row:nth-of-type(4)" do
      expect(page).to have_content "Minister Name"
    end

    expect(page).to have_content "Check your answers before recording this decision"
    click_button "Record DAO revocation"

    expect(page).to have_content "DAO revocation recorded successfully"
  end

  scenario "the Cancel buttons go to the correct places" do
    project = create(:conversion_project, directive_academy_order: true, assigned_to: user)

    visit project_path(project)

    click_on "Revoke a Directive Academy Order"

    click_on "Record DAO revocation"

    expect(page).to have_content "Record Directive Academy Order revocation"

    click_on "Continue"

    check "I confirm a minister has approved this decision"
    check "I confirm I have sent the letter confirming the revocation decision"
    check "I confirm I have saved a copy of the letter to the school’s SharePoint folder"
    click_button "Continue"

    click_on "Cancel"

    expect(page).to have_content("Task list")

    click_on "Revoke a Directive Academy Order"

    click_on "Record DAO revocation"

    expect(page).to have_content "Record Directive Academy Order revocation"

    click_on "Continue"

    check "I confirm a minister has approved this decision"
    check "I confirm I have sent the letter confirming the revocation decision"
    check "I confirm I have saved a copy of the letter to the school’s SharePoint folder"
    click_button "Continue"

    check "School closed or closing"
    check "Safeguarding concerns addressed"
    click_button "Continue"

    expect(page).to have_content "Minister’s name"
    fill_in "Minister’s name", with: "Incorrect Name"
    click_button "Continue"

    expect(page).to have_content "Date of decision"
    fill_in "Day", with: 1
    fill_in "Month", with: 1
    fill_in "Year", with: 2024
    click_button "Continue"

    expect(page).to have_content "Check your answers before recording this decision"

    within ".govuk-summary-list__row:nth-of-type(4)" do
      click_on "Change"
    end

    click_on "Cancel"

    expect(page).to have_content "Check your answers before recording this decision"
  end
end
