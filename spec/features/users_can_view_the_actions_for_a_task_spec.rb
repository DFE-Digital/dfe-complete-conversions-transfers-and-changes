require "rails_helper"

RSpec.feature "Users can view the Actions for a Task" do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:action) { create(:action) }
  let(:task_id) { action.task.id }
  let(:project_id) { action.task.section.project.id }

  before do
    mock_successful_api_responses(urn: 12345, ukprn: 10061021)

    sign_in_with_user(user)
  end

  scenario "user can view task and actions with hints and guidance" do
    visit project_task_path(project_id, task_id)

    # Task
    expect(page).to have_css(".govuk-heading-l", text: "Have you cleared the Supplementary funding agreement?")

    # Task hint
    expect(page).to have_link("View the model documents (opens in new tab)", href: "https://www.gov.uk/government/collections/convert-to-an-academy-documents-for-schools")

    # Task guidance
    find("span", text: "Help checking for changes").click
    expect(page).to have_link("contact the policy team (opens in new tab)", href: "https://educationgovuk.sharepoint.com/sites/lvedfe00116/SitePages/Commissioning%20Form.aspx")

    # Action
    expect(page).to have_content("Have you received the land questionnaire?")

    # Action hint
    expect(page).to have_css(".govuk-checkboxes__hint", text: "Select if you have received the land questionnaire")

    # Action guidance
    find("span", text: "Help receiving the land questionnaire").click
    expect(page).to have_link("check the guidance (opens in new tab)", href: "https://www.gov.uk/government/publications/academy-land-questionnaires")
  end
end
