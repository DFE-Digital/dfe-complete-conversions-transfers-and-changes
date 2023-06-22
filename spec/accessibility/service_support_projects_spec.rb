require "rails_helper"
require "axe-rspec"

RSpec.feature "Service support", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :service_support) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "> Conversion URNs > To create" do
    project = create(:conversion_project, assigned_to: user, urn: 123456, academy_urn: nil)

    visit without_academy_urn_service_support_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("URNs to create")
    check_accessibility(page)
  end

  scenario "> Conversion URNs > Added" do
    project = create(:conversion_project, assigned_to: user, urn: 123434, academy_urn: 123456)

    visit with_academy_urn_service_support_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("URNs added")
    check_accessibility(page)
  end

  scenario "> Local authorities" do
    local_authority = create(:local_authority)

    visit local_authorities_path

    expect(page).to have_content(local_authority.name)
    expect(page).to have_link("Local authorities")
    check_accessibility(page)
  end

  scenario "> Local authorities > View" do
    local_authority = create(:local_authority)

    visit local_authority_path(local_authority)

    expect(page).to have_content(local_authority.name)
    expect(page).to have_link("Local authorities")
    check_accessibility(page)
  end

  scenario "> Local authorities > Edit" do
    local_authority = create(:local_authority)

    visit edit_local_authority_path(local_authority)

    expect(page).to have_content(local_authority.name)
    expect(page).to have_link("Local authorities")
    check_accessibility(page)
  end
end
