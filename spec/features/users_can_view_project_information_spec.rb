require "rails_helper"

RSpec.feature "Users can view project information" do
  let(:user) { create(:user, email: "user@education.gov.uk") }
  let(:project) { create(:project, delivery_officer: user) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 12345)
    sign_in_with_user(user)
  end

  scenario "User views project information" do
    visit project_information_path(project_id)

    expect(page).to have_content("Project details")

    delivery_officer_label = page.find("dt", text: "Delivery officer")
    delivery_officer_label.ancestor(".govuk-summary-list__row").find("dd", text: "user@education.gov.uk")

    expect(page).to have_content("School details")

    original_school_name_label = page.find("dt", text: "Original school name")
    original_school_name_label.ancestor(".govuk-summary-list__row").find("dd", text: "Caludon Castle School")

    old_urn_label = page.find("dt", text: "Old Unique Reference Number")
    old_urn_label.ancestor(".govuk-summary-list__row").find("dd", text: "12345")
  end
end
