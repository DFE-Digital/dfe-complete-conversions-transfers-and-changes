require "rails_helper"

RSpec.feature "Users can create and view task level notes" do
  let(:user) { create(:user, email: "user@education.gov.uk") }
  let(:task) { create(:task) }
  let(:project) { task.project }
  let(:project_id) { project.id }
  let(:new_note_body) { "Just shared some *important* documents with the solictor." }
  let(:task_id) { task.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)

    travel_to Date.yesterday do
      create(:note, user: user, project: project, task: task)
    end

    freeze_time
  end

  scenario "User creates and views task level notes" do
    visit project_task_path(project_id, task_id)

    expect_page_to_have_note(
      user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    click_link "Add note" # Link styled as button

    expect(page).to have_current_path(new_project_note_path(project, task_id: task_id))
    expect(page).to have_field("note[task_id]", type: :hidden, with: task_id)

    fill_in "Enter note", with: new_note_body

    click_button("Add note")

    expect(page).to have_current_path(project_task_path(project_id, task_id))
    expect_page_to_have_note(user: user.full_name, date: Date.today.to_formatted_s(:govuk), body: new_note_body.delete("*"))
    expect(page.html).to include("<em>important</em>")
  end

  scenario "User edits a task level note" do
    visit project_task_path(project_id, task_id)

    expect_page_to_have_note(
      user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    click_link "Change"

    expect(page).to have_current_path(edit_project_note_path(project, Note.first))

    fill_in "Enter note", with: new_note_body

    click_button("Save note")

    expect(page).to have_current_path(project_task_path(project_id, task_id))
    expect_page_to_have_note(user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: new_note_body.delete("*"))
    expect(page).to_not have_content("Just had a very interesting phone call with the headteacher about land law")
  end

  scenario "User deletes a task level note" do
    visit project_task_path(project_id, task_id)

    expect_page_to_have_note(
      user: user.full_name, date: Date.yesterday.to_formatted_s(:govuk), body: "Just had a very interesting phone call with the headteacher about land law"
    )

    click_link "Change"

    expect(page).to have_current_path(edit_project_note_path(project, Note.first))

    click_link("Delete") # Link styled as button

    expect(page).to have_current_path(project_note_delete_path(project, Note.first))
    expect(page).to have_content(I18n.t("note.confirm_destroy.title"))
    expect(page).to have_content(I18n.t("note.confirm_destroy.guidance"))

    click_button("Delete")

    expect(page).to have_current_path(project_task_path(project_id, task_id))
  end

  private def expect_page_to_have_note(user:, date:, body:)
    expect(page).to have_content(user)
    expect(page).to have_content(date)
    expect(page).to have_content(body)
  end
end
