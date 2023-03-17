require "rails_helper"

RSpec.feature "Viewing regional casework services projects" do
  before do
    sign_in_with_user(user)
    mock_successful_api_response_to_create_any_project
    mock_pre_fetched_api_responses_for_any_establishment_and_trust
  end

  let!(:completed_project) { create(:conversion_project, urn: 121583, completed_at: Date.yesterday, assigned_to_regional_caseworker_team: true) }
  let!(:regional_project) { create(:conversion_project, urn: 121583, assigned_to_regional_caseworker_team: false) }
  let!(:first_project) { create(:conversion_project, urn: 115652, assigned_to_regional_caseworker_team: true) }
  let!(:second_project) { create(:conversion_project, urn: 103835, assigned_to_regional_caseworker_team: true) }

  context "when signed in as a Regional caseworker" do
    let(:user) { create(:user, :caseworker) }

    scenario "they can view all in progress projects" do
      view_in_progress_projects
    end
  end

  context "when signed in as a Regional caseworker team lead" do
    let(:user) { create(:user, :team_leader) }

    scenario "they can view all in progress projects" do
      view_in_progress_projects
    end
  end

  context "when signed in as a Regional delivery officer" do
    let(:user) { create(:user, :regional_delivery_officer) }

    scenario "they can view all in progress projects" do
      view_in_progress_projects
    end
  end

  def view_in_progress_projects
    visit regional_casework_services_in_progress_projects_path

    expect(page).to have_content(I18n.t("project.regional_casework_services.in_progress.title"))

    within("tbody") do
      expect(page).to have_content(first_project.urn)
      expect(page).to have_content(second_project.urn)

      expect(page).not_to have_content(completed_project.urn)
      expect(page).not_to have_content(regional_project.urn)
    end
  end
end
