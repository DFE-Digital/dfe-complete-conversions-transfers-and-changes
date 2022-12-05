require "rails_helper"
require "axe-rspec"

RSpec.feature "Test note accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:project) { create(:conversion_project, caseworker: user) }
  let(:section) { create(:section, project: project) }
  let(:task) { create(:task, section: section) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  describe "Project level notes" do
    let!(:note) { create(:note, user: user, project: project) }
    scenario "show notes page" do
      visit project_notes_path(project)

      expect(page).to have_content(note.body)
      expect(page).to be_axe_clean
    end

    scenario "new page" do
      visit new_project_note_path(project)

      expect(page).to have_content("Enter note")
      expect(page).to be_axe_clean
    end

    scenario "edit page" do
      visit edit_project_note_path(project, note)

      expect(page).to have_content(note.body)
      expect(page).to be_axe_clean
    end

    scenario "deleted page" do
      visit project_note_delete_path(project, note)

      expect(page).to have_content("Are you sure you want to delete this note?")
      expect(page).to be_axe_clean
    end
  end

  describe "Task notes" do
    let!(:task_note) { create(:note, project: project, task: task) }
    scenario "new page" do
      visit new_project_note_path(project, task)

      expect(page).to have_content("Enter note")
      expect(page).to be_axe_clean
    end

    scenario "show page" do
      visit project_task_path(project, task)

      expect(page).to have_content(task_note.body)
      expect(page).to be_axe_clean
    end
  end
end
