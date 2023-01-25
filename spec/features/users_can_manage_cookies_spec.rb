require "rails_helper"

RSpec.feature "Users can manage cookies" do
  context "when a user is not signed in" do
    scenario "they can view a page which describes the cookies used by the application" do
      visit cookies_path

      expect(page).to have_content("Essential cookies")
    end

    scenario "they can view the cookies banner" do
      visit root_path

      expect(page).to have_content("Cookies on #{I18n.t("service_name")}")
    end

    scenario "once optional cookies are set, the banner doesn't show" do
      visit root_path

      click_on "Accept optional cookies"

      expect(page).not_to have_content("Cookies on #{I18n.t("service_name")}")
    end

    scenario "they accept optional cookies from the banner" do
      visit root_path

      click_on "Accept optional cookies"

      expect(page.body).to include(I18n.t("cookies.updated_message.true"))

      visit cookies_path
      expected_option = find_field("Yes")

      expect(expected_option.checked?).to eq(true)
    end

    scenario "they reject optional cookies from the banner" do
      visit root_path

      click_on "Reject optional cookies"

      expect(page.body).to include(I18n.t("cookies.updated_message.false"))

      visit cookies_path
      expected_option = find_field("No")

      expect(expected_option.checked?).to eq(true)
    end

    context "when the user has yet to make a choice" do
      scenario "we reject optional cookies until told otherwise" do
        visit cookies_path
        expected_option = find_field("No")

        expect(expected_option.checked?).to eq(true)
      end
    end

    scenario "they can accept optional cookies" do
      visit cookies_path

      choose "Yes"
      click_on "Continue"

      visit cookies_path
      expected_option = find_field("Yes")

      expect(expected_option.checked?).to eq(true)
    end

    scenario "they can reject optional cookies" do
      visit cookies_path

      choose "No"
      click_on "Continue"

      visit cookies_path
      expected_option = find_field("No")

      expect(expected_option.checked?).to eq(true)
    end
  end
end
