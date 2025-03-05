require "rails_helper"

RSpec.feature "Users can create and view notes" do
  let(:user) { create(:user, :caseworker, email: "user@education.gov.uk") }
  let(:project) { create(:conversion_project) }
  let(:project_id) { project.id }
  let(:new_note_body) { "Just shared some *important* documents with the solictor." }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: 10061021)
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
    expect(page).to have_link("Back", href: project_notes_path(project_id))
    expect(page).to have_link("Cancel", href: project_notes_path(project_id))

    fill_in "Enter note", with: new_note_body

    click_button("Add note")

    expect(page).to have_current_path(project_notes_path(project_id))
    expect_page_to_have_note(user: user.full_name, date: Date.today.to_formatted_s(:govuk), body: new_note_body.delete("*"))
    expect(page.html).to include("<em>important</em>")
  end

  context "when the project is a conversion project" do
    let(:project) { create(:conversion_project) }

    scenario "the user can still create a note" do
      visit project_notes_path(project_id)

      expect_page_to_have_note(
        user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
      )

      click_link "Add note" # Link styled as button

      expect(page).to have_current_path(new_project_note_path(project))
      expect(page).to have_link("Back", href: project_notes_path(project_id))
      expect(page).to have_link("Cancel", href: project_notes_path(project_id))

      fill_in "Enter note", with: new_note_body

      click_button("Add note")

      expect(page).to have_current_path(project_notes_path(project_id))
      expect_page_to_have_note(user: user.full_name, date: Date.today.to_formatted_s(:govuk), body: new_note_body.delete("*"))
      expect(page.html).to include("<em>important</em>")
    end
  end

  scenario "User edits a note" do
    visit project_notes_path(project_id)

    expect_page_to_have_note(
      user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    click_link "Edit"

    expect(page).to have_current_path(edit_project_note_path(project, Note.first))
    expect(page).to have_link("Back", href: project_notes_path(project_id))

    fill_in "Enter note", with: new_note_body

    click_button("Save note")

    expect(page).to have_current_path(project_notes_path(project_id))
    expect_page_to_have_note(user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: new_note_body.delete("*"))
    expect(page).to_not have_content("Just had a very interesting phone call with the headteacher about land law")
  end

  scenario "User deletes a note" do
    visit project_notes_path(project_id)
    expect(page).to have_content(I18n.t("note.index.notes"))

    expect_page_to_have_note(
      user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    click_link "Edit"

    expect(page).to have_current_path(edit_project_note_path(project, Note.first))

    click_link("Delete") # Link styled as button

    expect(page).to have_current_path(project_note_delete_path(project, Note.first))
    expect(page).to have_content(I18n.t("note.confirm_destroy.title"))
    expect(page).to have_content(I18n.t("note.confirm_destroy.guidance"))

    click_button("Delete")

    expect(page).to have_current_path(project_notes_path(project_id))
    expect(page).to have_content(I18n.t("note.index.no_notes_yet"))
  end

  private def expect_page_to_have_note(user:, date:, body:)
    expect(page).to have_content(user)
    expect(page).to have_content(date)
    expect(page).to have_content(body)
  end
end
