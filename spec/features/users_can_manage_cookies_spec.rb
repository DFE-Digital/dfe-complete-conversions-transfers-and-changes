require "rails_helper"

RSpec.feature "Users can manage cookies" do
  context "when a user is not signed in" do
    scenario "they can view a page which describes the cookies used by the application" do
      visit cookies_path

      expect(page).to have_content("Essential cookies")
    end

    context "when the user has yet to make a choice" do
      scenario "we reject optional cookies until told otherwise" do
        visit cookies_path
        reject_option = find_field("No")

        expect(reject_option.checked?).to eq(true)
      end
    end

    scenario "they can accept optional cookies" do
      visit cookies_path

      choose "Yes"
      click_on "Continue"

      visit cookies_path
      accept_option = find_field("Yes")

      expect(accept_option.checked?).to eq(true)
    end

    scenario "they can reject optional cookies" do
      visit cookies_path

      choose "No"
      click_on "Continue"

      visit cookies_path
      reject_option = find_field("No")

      expect(reject_option.checked?).to eq(true)
    end
  end
end
