require "rails_helper"

RSpec.feature "Export users can see the exports landing page" do
  scenario "other users do not see the navigation" do
    user = create(:regional_delivery_officer_user)

    sign_in_with_user(user)
    visit all_in_progress_projects_path

    expect(page).not_to have_link("Exports")
  end

  scenario "an ESFA user can see the exports landing page" do
    user = create(:user, team: :education_and_skills_funding_agency)

    sign_in_with_user(user)
    click_on "Exports"

    expect(page).to have_content("You can find out who should be sent the funding agreement letters.")
    expect(page).to have_content("You can check details about schools' risk protection arrangements and start-up grant funding.")
    expect(page).to have_content("You can get information pre-opening grants for schools becoming academies.")
  end

  scenario "an AOPU user can see the exports landing page" do
    user = create(:user, team: :academies_operational_practice_unit)

    sign_in_with_user(user)
    click_on "Exports"

    expect(page).to have_content("You can find out who should be sent the funding agreement letters.")
    expect(page).to have_content("You can check details about schools' risk protection arrangements and start-up grant funding.")
    expect(page).to have_content("You can get information pre-opening grants for schools becoming academies.")
  end

  scenario "a business support user can see the exports landing page" do
    user = create(:user, team: :business_support)

    sign_in_with_user(user)
    click_on "Exports"

    expect(page).to have_content("You can find out who should be sent the funding agreement letters.")
    expect(page).to have_content("You can check details about schools' risk protection arrangements and start-up grant funding.")
    expect(page).to have_content("You can get information pre-opening grants for schools becoming academies.")
  end
end
