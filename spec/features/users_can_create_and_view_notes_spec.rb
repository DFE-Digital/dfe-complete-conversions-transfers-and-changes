require "rails_helper"

RSpec.feature "Users can create and view notes" do
  let(:user) { create(:user, email: "user@education.gov.uk") }
  let(:project) { create(:project) }
  let(:project_id) { project.id }
  let(:new_note_body) { "Just shared some important documents with the solictor." }
  let(:existing_note_created_at) {}

  before do
    mock_successful_api_responses(urn: 12345, ukprn: 10061021)
    sign_in_with_user(user)

    travel_to Date.yesterday do
      create(:note, user: user, project: project)
    end

    freeze_time
  end

  scenario "User creates and views notes" do
    visit project_notes_path(project_id)

    expect_page_to_have_note(
      user: user.email, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    fill_in "Notes", with: new_note_body

    click_button("Add note")

    expect_page_to_have_note(user: user.email, date: Date.today.to_formatted_s(:govuk), body: new_note_body)
  end

  private def expect_page_to_have_note(user:, date:, body:)
    expect(page).to have_content(user)
    expect(page).to have_content(date)
    expect(page).to have_content(body)
  end
end
