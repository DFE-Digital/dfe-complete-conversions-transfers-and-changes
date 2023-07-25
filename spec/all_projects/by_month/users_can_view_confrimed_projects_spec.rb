require "rails_helper"

RSpec.feature "Users can view confirmed projects" do
  scenario "they can see the academy order type" do
    sign_in_with_user(create(:user))
    mock_all_academies_api_responses
    create(:conversion_project, conversion_date: Date.today.next_month.at_beginning_of_month, conversion_date_provisional: false)

    visit confirmed_all_opening_projects_path

    within("thead") do
      expect(page).to have_content("Academy order type")
    end
    within("tbody") do
      expect(page).to have_content("AO (Academy Order)")
    end
  end
end
