require "rails_helper"

RSpec.feature "Users can create and view notes" do
  let(:user) { create(:user, email: "user@education.gov.uk") }
  let(:project) { create(:project) }
  let(:project_id) { project.id }
  let(:new_note_body) { "Just shared some *important* documents with the solictor." }
  let(:existing_note_created_at) {}

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)

    travel_to Date.yesterday do
      create(:note, user: user, project: project)
    end

    freeze_time
  end

  scenario "User creates and views notes" do
    visit project_notes_path(project_id)

    expect_page_to_have_note(
      user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    click_link "Add note" # Link styled as button

    expect(page).to have_current_path(new_project_note_path(project))

    fill_in "Enter note", with: new_note_body

    click_button("Add note")

    expect(page).to have_current_path(project_notes_path(project_id))
    expect_page_to_have_note(user: user.full_name, date: Date.today.to_formatted_s(:govuk), body: new_note_body.delete("*"))
    expect(page.html).to include("<em>important</em>")
  end

  scenario "User edits a note" do
    visit project_notes_path(project_id)

    expect_page_to_have_note(
      user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    click_link "Edit"

    expect(page).to have_current_path(edit_project_note_path(project, Note.first))

    fill_in "Enter note", with: new_note_body

    click_button("Save note")

    expect(page).to have_current_path(project_notes_path(project_id))
    expect_page_to_have_note(user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: new_note_body.delete("*"))
    expect(page).to_not have_content("Just had a very interesting phone call with the headteacher about land law")
  end

  private def expect_page_to_have_note(user:, date:, body:)
    expect(page).to have_content(user)
    expect(page).to have_content(date)
    expect(page).to have_content(body)
  end
end
