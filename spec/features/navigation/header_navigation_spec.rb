require "rails_helper"

RSpec.feature "Header navigation" do
  context "when the user is not signed in" do
    it "is not rendered" do
      visit root_path

      expect(page).not_to have_link "All projects"
      expect(page).not_to have_css ".moj-header__navigation"
    end
  end

  context "when the user is signed in and has no role" do
    it "the appropriate navigation is rendered" do
      user = create(:user)
      sign_in_with_user(user)
      visit root_path

      expect(page).not_to have_link "All projects"
      expect(page).not_to have_css ".moj-header__navigation"
    end
  end

  context "when the user is signed in and has a role" do
    it "the appropriate navigation is rendered" do
      user = create(:user, :caseworker)
      sign_in_with_user(user)
      visit root_path

      expect(page).to have_link "Your projects"
      expect(page).to have_link "All projects"
      expect(page).to have_css ".moj-header__navigation"
    end
  end
end
