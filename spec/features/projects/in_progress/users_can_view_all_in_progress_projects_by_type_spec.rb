require "rails_helper"

RSpec.feature "Users can view all in progress projects by type" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let!(:conversion_project) { create(:conversion_project, urn: 123456) }
  let!(:transfer_project) { create(:transfer_project, urn: 165432) }

  scenario "view all projects in a table" do
    visit all_all_in_progress_projects_path

    expect(page).to have_content conversion_project.urn
    expect(page).to have_content transfer_project.urn
  end

  scenario "view all conversion projects in a table" do
    visit all_all_in_progress_projects_path

    click_on "Conversions"

    expect(page).to have_content conversion_project.urn
    expect(page).not_to have_content transfer_project.urn
  end

  scenario "view all transfer projects in a table" do
    visit all_all_in_progress_projects_path

    click_on "Transfers"

    expect(page).to have_content transfer_project.urn
    expect(page).not_to have_content conversion_project.urn
  end

  scenario "view all form a multi academy trust projects in a table" do
    # This view loads n number of ProjectGroups which eager load the
    # assigned_to associations on their projects, showing a single ProjectGroup
    # uses ALL assigned_to.
    #
    # Whilst every ProjectGroup in this view  will use 1 single assigned_to,
    # Bullet will raise a false positive on the
    # projects_establishment_name_list helper that fetches the establishment
    # names, where the assigned_to is not used hence the warning.
    #
    # The simplest fix seems to be to disable Bullet where we know it is making
    # a false positive.
    Bullet.enable = false

    create(:conversion_project, :form_a_mat, urn: 132198)
    create(:transfer_project, :form_a_mat, urn: 131182)

    test_client = Api::AcademiesApi::Client.new
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
    allow(test_client).to receive(:get_establishment).with(132198).and_return(double(object: double(name: "First Establishment"), error: nil))
    allow(test_client).to receive(:get_establishment).with(131182).and_return(double(object: double(name: "Last Establishment"), error: nil))

    visit all_all_in_progress_projects_path

    click_on "Form a MAT"

    within("tbody.govuk-table__body") do
      expect(page).to have_content "First Establishment"
      expect(page).to have_content "Last Establishment"

      expect(page).not_to have_content conversion_project.establishment.name
    end

    # Bullet re-enabled
    Bullet.enable = true
  end
end
