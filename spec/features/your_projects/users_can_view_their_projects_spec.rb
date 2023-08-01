require "rails_helper"

RSpec.feature "Users can view their projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:regional_casework_services_user) }

  scenario "they can see conversions assigned to them" do
    project = create(:conversion_project, assigned_to: user)

    visit in_progress_your_projects_path

    expect(page).to have_content(project.establishment.name)
    expect(page).to have_content(project.urn)
    expect(page).to have_content(project.incoming_trust.name)
    expect(page).to have_content("provisional")
    expect(page).to have_content("Not yet")
    expect(page).to have_content("Region")
  end

  scenario "they can see transfers assigned to them" do
    # TODO:  we have to disable bullet for this test as we eager load the TasksData for conversions, which
    # use the all_conditions_met value, but transfers do not use it. Once transfers has the concept of
    # all conditions met - this can be removed
    Bullet.enable = false
    project = create(:transfer_project, assigned_to: user)

    visit in_progress_your_projects_path

    expect(page).to have_content(project.establishment.name)
    expect(page).to have_content(project.urn)
    expect(page).to have_content(project.incoming_trust.name)
    expect(page).to have_content(project.outgoing_trust.name)
    expect(page).to have_content("provisional")
    expect(page).to have_content("Region")
    Bullet.enable = true
  end

  context "when they are NOT in the Regional casework services team" do
    let(:user) { create(:regional_delivery_officer_user) }

    scenario "they do not see the region" do
      conversion_project = create(:conversion_project, assigned_to: user)
      transfer_project = create(:transfer_project, assigned_to: user)

      visit in_progress_your_projects_path

      expect(page).to have_content(conversion_project.urn)
      expect(page).to have_content(transfer_project.urn)
      expect(page).not_to have_content("Region")
    end
  end
end
