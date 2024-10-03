require "rails_helper"

RSpec.feature "Export users can see the exports landing page" do
  scenario "other users do not see the navigation" do
    user = create(:regional_delivery_officer_user)

    sign_in_with_user(user)
    visit all_all_in_progress_projects_path

    expect(page).not_to have_link("Exports")
  end

  scenario "a data consumers user can see the exports landing page" do
    user = create(:user, team: :data_consumers)

    sign_in_with_user(user)
    click_on "Exports"

    expect(page).to have_content("funding agreement letter contacts, RPA and start-up grants")
    expect(page).to have_content("pre-opening grants for schools becoming academies")
    expect(page).to have_content("academies due to transfer in a date range")
    expect(page).to have_content("pre-transfer grants for academies joining a different trust")
  end

  scenario "a business support user can see the exports landing page" do
    user = create(:user, team: :business_support)

    sign_in_with_user(user)
    click_link "All projects"
    click_link "Exports"

    expect(page).to have_content("funding agreement letter contacts, RPA and start-up grants")
    expect(page).to have_content("pre-opening grants for schools becoming academies")
    expect(page).to have_content("academies due to transfer in a date range")
    expect(page).to have_content("pre-transfer grants for academies joining a different trust")
  end

  scenario "a service support user can see the exports landing page" do
    user = create(:user, team: :service_support)

    sign_in_with_user(user)
    click_link "All projects"
    click_link "Exports"

    expect(page).to have_content("funding agreement letter contacts, RPA and start-up grants")
    expect(page).to have_content("pre-opening grants for schools becoming academies")
    expect(page).to have_content("academies due to transfer in a date range")
    expect(page).to have_content("pre-transfer grants for academies joining a different trust")
  end
end
