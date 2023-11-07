require "rails_helper"

RSpec.feature "Users can view their team's projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "within the in progress tab" do
    describe "when the current user is a regional delivery officer" do
      let(:user) { create(:regional_delivery_officer_user, team: :london) }
      scenario "they can see the column heading Team" do
        create(:conversion_project, assigned_to: user, region: :london)

        visit in_progress_team_projects_path

        within("thead") do
          expect(page).to have_content("Team")
          expect(page).not_to have_content("Region")
        end
      end
    end

    describe "when the current user is a regional case worker" do
      let(:user) { create(:regional_casework_services_user) }
      scenario "they can see the column heading Region" do
        create(:conversion_project, assigned_to: user, team: :regional_casework_services)

        visit in_progress_team_projects_path

        within("thead") do
          expect(page).to have_content("Region")
          expect(page).not_to have_content("Team")
        end
      end
    end
  end

  context "within the new tab" do
    let(:user) { create(:regional_delivery_officer_user, team: :london) }
    scenario "they can navigate to the new page and see projects listed in created at date order" do
      project_newest = create(:conversion_project, team: "regional_casework_services", conversion_date: Date.today.at_beginning_of_month + 1.month, created_at: DateTime.now)
      project_oldest = create(:conversion_project, team: "regional_casework_services", conversion_date: Date.today.at_beginning_of_month + 1.month, created_at: DateTime.now)

      visit team_projects_path

      expect(page).to have_content("New")
      expect(page).to have_content(project_newest.urn)
      expect(page).to have_content(project_oldest.urn)
    end
  end
end
