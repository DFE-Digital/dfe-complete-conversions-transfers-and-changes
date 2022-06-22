require "rails_helper"

RSpec.feature "Users can sign in to the application" do
  context "when the authentication is successful" do
    let(:user_email_address) { "user@education.gov.uk" }

    before do
      User.create!(email: user_email_address)
      OmniAuth.config.mock_auth[:microsoft_graph] = OmniAuth::AuthHash.new({
        info: {
          email: user_email_address
        }
      })
      OmniAuth.config.test_mode = true
    end

    scenario "from the sign in page" do
      visit sign_in_path
      click_button("Sign in with your DfE Microsoft account")

      expect(page).not_to have_button(I18n.t("sign_in.button"))
      expect(page).to have_users_email_address
    end

    scenario "from any page, they are redirected to the sign in page" do
      visit root_path
      click_button("Sign in with your DfE Microsoft account")

      expect(page).to have_users_email_address
    end
  end

  context "when the authentication fails" do
    before do
      OmniAuth.config.mock_auth[:microsoft_graph] = :invalid_credentials
      OmniAuth.config.test_mode = true
    end

    scenario "they are redirected to the sign in page and shown a helpful message" do
      visit sign_in_path
      click_button("Sign in with your DfE Microsoft account")

      expect(page).to have_button(I18n.t("sign_in.button"))
      within(".flash") do
        expect(page).to have_content(I18n.t("sign_in.message.failure"))
      end
    end
  end

  def have_users_email_address
    have_content(user_email_address)
  end
end
