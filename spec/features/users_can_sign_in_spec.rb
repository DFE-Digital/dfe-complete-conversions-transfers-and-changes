require "rails_helper"

RSpec.feature "Users can sign in to the application" do
  context "when the authentication is successful" do
    let(:user) { create(:user) }

    before do
      mock_successful_authentication(user.email)
    end

    scenario "from the sign in page" do
      visit sign_in_path
      click_button(I18n.t("sign_in.button"))

      expect(page).not_to have_button(I18n.t("sign_in.button"))
      expect(page).to have_content(user.email)
    end

    scenario "from any page, they are redirected to the sign in page" do
      visit root_path
      click_button(I18n.t("sign_in.button"))

      expect(page).to have_content(user.email)
    end
  end

  context "when the authentication fails" do
    before do
      mock_unsuccessful_authentication
    end

    scenario "they are redirected to the sign in page and shown a helpful message" do
      visit sign_in_path
      click_button(I18n.t("sign_in.button"))

      expect(page).to have_button(I18n.t("sign_in.button"))
      within(".flash") do
        expect(page).to have_content(I18n.t("sign_in.message.failure"))
      end
    end
  end
end
