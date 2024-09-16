require "rails_helper"

RSpec.feature "Viewing regional casework services projects" do
  context "when there are no projects" do
    before do
      user = create(:user, :team_leader)
      sign_in_with_user(user)
    end

    scenario "they can view a helpful message" do
      visit in_progress_team_projects_path

      expect(page).to have_content(I18n.t("project.table.in_progress.empty"))

      visit completed_team_projects_path

      expect(page).to have_content(I18n.t("project.table.completed.empty"))

      visit unassigned_team_projects_path

      expect(page).to have_content(I18n.t("project.table.unassigned.empty"))
    end
  end

  context "navigation" do
    before do
      sign_in_with_user(user)
    end

    context "when the user is a team_leader" do
      let(:user) { create(:user, :team_leader) }

      scenario "they can see a link to the unassigned projects page" do
        visit in_progress_team_projects_path

        expect(page.find("nav.moj-primary-navigation")).to have_content "Unassigned"
      end

      scenario "the Team projects link leads to the unassigned page" do
        visit root_path

        click_on "Your team projects"

        expect(page.find("h1")).to have_content("Your team unassigned projects")
      end
    end

    context "when the user is a regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }

      scenario "they can NOT see a link to the unassigned projects page" do
        visit in_progress_team_projects_path

        expect(page.find("nav.moj-primary-navigation")).to_not have_content "Unassigned"
      end

      scenario "the Team projects link leads to the in-progress page" do
        visit root_path

        click_on "Your team projects"

        expect(page.find("h1")).to have_content("Your team projects in progress")
      end
    end

    context "when the user is a caseworker" do
      let(:user) { create(:user, :caseworker) }

      scenario "they can NOT see a link to the unassigned projects page" do
        visit in_progress_team_projects_path

        expect(page.find("nav.moj-primary-navigation")).to_not have_content "Unassigned"
      end

      scenario "the Team projects link leads to the in-progress page" do
        visit root_path

        click_on "Your team projects"

        expect(page.find("h1")).to have_content("Your team projects in progress")
      end
    end
  end
end
