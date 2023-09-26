require "rails_helper"

RSpec.feature "Users can view school diocese details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  scenario "the diocese details" do
    within("#projectDetails") do
      expect(page).to have_content(project.establishment.diocese_name)
    end
  end
end
