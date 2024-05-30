require "rails_helper"

RSpec.feature "ESFA users can export" do
  scenario "other users do not see the navigation" do
    user = create(:regional_delivery_officer_user)

    sign_in_with_user(user)
    visit all_all_in_progress_projects_path

    expect(page).not_to have_link("Exports")
  end

  scenario "they can see the navigation" do
    user = create(:user, team: :education_and_skills_funding_agency)

    sign_in_with_user(user)
    visit all_all_in_progress_projects_path

    expect(page).to have_link("Exports")
  end
end
