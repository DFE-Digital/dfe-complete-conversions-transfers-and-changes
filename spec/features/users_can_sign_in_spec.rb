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
      expect(user.reload.active_directory_user_id).to eq "b5095c3e-0141-4478-81ad-99d0fbd087ed"
    end

    scenario "from any page, they are redirected to the sign in page" do
      visit root_path

      expect(page).to have_content("Sign in")
      expect(page).to have_button(I18n.t("sign_in.button"))
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
        expect(page).not_to have_css(".notice")
      end
    end
  end
end
