require "rails_helper"

RSpec.feature "Users can view a project summary" do
  let(:user) { create(:user) }

  before do
    sign_in_with_user(user)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  context "when they view a single voluntary conversion project" do
    scenario "they see the route" do
      project = create(:voluntary_conversion_project, caseworker: user)

      visit project_path(project)

      within("#project-summary") do
        expect(page).to have_content("Voluntary")
      end
    end
  end

  context "when they view a single involuntary conversion project" do
    scenario "they see the route" do
      project = create(:involuntary_conversion_project, caseworker: user)
      visit project_path(project)

      within("#project-summary") do
        expect(page).to have_content("Involuntary")
      end
    end
  end
end
