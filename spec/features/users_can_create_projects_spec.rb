require "rails_helper"

RSpec.feature "Users can create a new project" do
  before(:each) do
    sign_in_with_user("user@education.gov.uk")
    visit new_project_path
  end

  context "the URN is valid" do
    scenario "a new project is created" do
      fill_in "project-urn-field", with: "19283746"
      click_button("Continue")
      expect(page).to have_content("19283746")
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
