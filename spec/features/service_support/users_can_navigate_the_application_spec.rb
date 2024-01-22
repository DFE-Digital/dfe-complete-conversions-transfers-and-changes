require "rails_helper"

RSpec.feature "Service support users can navigate the application" do
  let(:user) { create(:user, :service_support) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "when the sign in they are redirected to the appropriate view and can see the sub navigation" do
    expect(page).to have_content("Service support")
    expect(page).to have_link("URNs to create")
    expect(page).to have_link("URNs added")
    expect(page).to have_link("Local authorities")
  end

  scenario "they can view the projects that need records added to GIAS i.e. those that require academy URNs" do
    project = create(:conversion_project, academy_urn: nil)

    click_link("URNs to create")

    expect(page).to have_content("URNs to create")
    expect(page).to have_content(project.urn)
  end

  scenario "they can view the projects that have a GIAS Establishment record" do
    project = create(:conversion_project, academy_urn: 149061)
    _establishment = create(:gias_establishment, urn: 149061)

    click_link("URNs added")

    expect(page).to have_content("URNs added")
    expect(page).to have_content(project.academy_urn)
  end

  scenario "they can view the projects that have an academy URN but we don't yet have a local GIAS Establishment record for" do
    project = create(:conversion_project, academy_urn: 149061)

    click_link("URNs added")

    expect(page).to have_content("URNs added")
    expect(page).to have_content(project.academy_urn)
  end

  scenario "they can view all local authorities" do
    local_authority = create(:local_authority)

    click_link("Local authorities")

    expect(page).to have_content("Local authorities")
    expect(page).to have_content(local_authority.name)
  end
end
