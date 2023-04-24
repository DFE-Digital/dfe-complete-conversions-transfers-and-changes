require "rails_helper"

RSpec.feature "Users can view local authority details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  scenario "they can view the name" do
    within("#localAuthorityDetails") do
      expect(page).to have_content(project.establishment.local_authority_name)
    end
  end
end
