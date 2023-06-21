require "rails_helper"
require "axe-rspec"

RSpec.feature "Test note accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :caseworker, email: "user1@education.gov.uk") }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  describe "Project level notes" do
    let!(:note) { create(:note, user: user, project: project) }
    scenario "show notes page" do
      visit project_notes_path(project)

      expect(page).to have_content(note.body)
      check_accessibility(page)
    end

    scenario "new page" do
      visit new_project_note_path(project)

      expect(page).to have_content("Enter note")
      check_accessibility(page)
    end

    scenario "edit page" do
      visit edit_project_note_path(project, note)

      expect(page).to have_content(note.body)
      check_accessibility(page)
    end

    scenario "deleted page" do
      visit project_note_delete_path(project, note)

      expect(page).to have_content("Are you sure you want to delete this note?")
      check_accessibility(page)
    end
  end

  describe "Task notes" do
    let(:task_identifier) { "handover" }
    let!(:task_note) { create(:note, :task_level_note, project: project, task_identifier: task_identifier) }
    scenario "new page" do
      visit new_project_note_path(project, task_identifier)

      expect(page).to have_content("Enter note")
      check_accessibility(page)
    end

    scenario "show page" do
      visit project_edit_task_path(project, task_identifier)

      expect(page).to have_content(task_note.body)
      check_accessibility(page)
    end
  end
end
