require "rails_helper"

RSpec.feature "ESFA users can export" do
  scenario "other users do not see the navigation" do
    user = create(:regional_delivery_officer_user)

    sign_in_with_user(user)
    visit all_in_progress_projects_path

    expect(page).not_to have_link("Exports")
  end

  scenario "they can see the navigation" do
    user = create(:user, team: :education_and_skills_funding_agency)

    sign_in_with_user(user)
    visit all_in_progress_projects_path

    expect(page).to have_link("Exports")
  end

  scenario "they can view six months of exports" do
    user = create(:user, team: :education_and_skills_funding_agency)

    sign_in_with_user(user)
    visit all_in_progress_projects_path

    click_on "Exports"

    expect(page).to have_link(Date.today.to_fs(:govuk_month))
    expect(page).to have_link(Date.today.next_month.to_fs(:govuk_month))
  end

  scenario "they can view six months of exports" do
    user = create(:user, team: :education_and_skills_funding_agency)

    sign_in_with_user(user)
    visit all_in_progress_projects_path

    click_on "Exports"

    click_on "Export for #{Date.today.to_fs(:govuk_month)}"

    expect(page).to have_link("Download csv file")
  end
end
