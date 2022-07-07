require "rails_helper"

RSpec.feature "Users can create a new project" do
  let(:mock_workflow) { file_fixture("workflows/conversion.yml") }

  before(:each) do
    sign_in_with_user(create(:user))
    visit new_project_path

    allow(YAML).to receive(:load_file).with("workflows/conversion.yml").and_return(
      YAML.load_file(mock_workflow)
    )
  end

  context "the URN is valid" do
    scenario "a new project is created" do
      fill_in "project-urn-field", with: "19283746"
      click_button("Continue")
      expect(page).to have_content("Project task list")
      expect(page).to have_content("Starting the project")
      expect(page).to have_content("Understand history and complete handover from Pre-AB")
    end
  end

  context "the URN is empty" do
    scenario "the user is shown an error message" do
      click_button("Continue")
      expect(page).to have_content("can't be blank")
    end
  end

  context "the URN is invalid" do
    scenario "the user is shown an error message" do
      fill_in "project-urn-field", with: "three"
      click_button("Continue")
      expect(page).to have_content("is not a number")
    end
  end
end
