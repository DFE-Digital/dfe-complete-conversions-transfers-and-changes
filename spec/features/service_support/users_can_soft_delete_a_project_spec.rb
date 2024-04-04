require "rails_helper"

RSpec.feature "Service support users can soft delete a project" do
  let(:user) { create(:service_support_user) }

  before do
    sign_in_with_user(user)
    mock_successful_api_response_to_create_any_project
  end

  scenario "a service support user can 'soft delete' a project" do
    project_to_delete = create(:conversion_project, assigned_to: create(:regional_casework_services_user))

    visit project_path(project_to_delete)
    expect(page).to have_content(project_to_delete.urn.to_s)

    click_link "Delete project"
    expect(page).to have_content("Delete #{project_to_delete.establishment.name}")
    expect(page).to have_content("You are about to delete this project")

    click_button("Delete project")
    expect(page).to have_content("The project was deleted")
    expect(page).to_not have_content(project_to_delete.establishment.name)

    expect(project_to_delete.reload.state).to eq("deleted")
  end
end
