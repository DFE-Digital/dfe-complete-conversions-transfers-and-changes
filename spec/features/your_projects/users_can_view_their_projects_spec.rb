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
    expect(page).to have_content(I18n.t("none"))
  end

  scenario "they can see transfers assigned to them" do
    project = create(:transfer_project, assigned_to: user)

    visit in_progress_your_projects_path

    expect(page).to have_content(project.establishment.name)
    expect(page).to have_content(project.urn)
    expect(page).to have_content(project.incoming_trust.name)
    expect(page).to have_content(project.outgoing_trust.name)
  end

  scenario "they do not see deleted projects" do
    project = create(:transfer_project, :deleted, assigned_to: user)

    visit in_progress_your_projects_path

    expect(page).to_not have_content(project.establishment.name)
    expect(page).to_not have_content(project.urn)
  end

  context "when they ARE in the Regional casework services team" do
    context "and they are NOT a team manager" do
      before {
        user.save # perform the on_save callbacks
        expect(user.manage_team).to be false
      }

      it "they can access the 'Your projects' section" do
        visit in_progress_your_projects_path
        expect(page).to have_link("Your project")
      end
    end

    context "and they ARE a team manager" do
      before {
        user.update_column(:manage_team, true)
        user.save # perform the on_save callbacks
        expect(user.reload.manage_team).to be true
      }

      it "they can NOT access the 'Your projects' section" do
        visit "/"
        expect(page).to_not have_link("Your project")
      end
    end
  end

  context "when they are NOT in the Regional casework services team" do
    let(:user) { create(:regional_delivery_officer_user) }

    scenario "they do not see the region" do
      conversion_project = create(:conversion_project, assigned_to: user)
      transfer_project = create(:transfer_project, assigned_to: user)

      visit in_progress_your_projects_path

      expect(page).to have_content(conversion_project.urn)
      expect(page).to have_content(transfer_project.urn)
      within("table") do
        expect(page).not_to have_content("Region")
      end
    end
  end
end
