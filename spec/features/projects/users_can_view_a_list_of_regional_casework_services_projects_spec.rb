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
end
