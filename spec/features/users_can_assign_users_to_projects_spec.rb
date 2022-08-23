require "rails_helper"

RSpec.feature "Users can assign users to projects" do
  before do
    mock_successful_api_responses(urn: project.urn, ukprn: project.trust_ukprn)
    sign_in_with_user(user)
  end

  context "when the user is a team lead" do
    let(:user) { create(:user, :team_leader) }
    let!(:caseworker_user) { create(:user, :caseworker) }
    let(:project) { create_unassigned_project }

    scenario "they can assign a user to the caseworker role" do
      visit project_path(project)
      click_on "Edit"
      select caseworker_user.email, from: "Caseworker"
      click_on "Continue"
      click_on "Project information"

      expect(page).to have_content caseworker_user.email
    end
  end
end
