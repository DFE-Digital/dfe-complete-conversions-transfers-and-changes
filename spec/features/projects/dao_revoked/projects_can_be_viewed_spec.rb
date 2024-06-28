require "rails_helper"

RSpec.feature "DAO projects can be viewed" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "on the all project dao revoked view" do
    dao_project = create(:conversion_project, state: :dao_revoked, directive_academy_order: true)
    dao_revocation = create(:dao_revocation, project: dao_project)

    visit all_dao_revoked_projects_path

    expect(page).to have_content "Conversions with a revoked DAO (Directive Academy Order)"
    expect(page).to have_content dao_revocation.date_of_decision.to_fs(:govuk)
  end
end
