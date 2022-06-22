require "rails_helper"

RSpec.describe "Sign in" do
  context "when the user is signed out" do
    it "redirects them to the sign in page and shows a helpful message" do
      get root_path

      expect(request).to redirect_to(sign_in_path)
      expect(flash.to_h.values).to include I18n.t("sign_in.message.unauthenticated")
    end
  end

  context "when the user is signed in" do
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

    it "loads the requested page" do
      get root_path
      follow_redirect!

      expect(response).to have_http_status(:success)
    end
  end

  context "when the users is not known by the application" do
    let(:user_email_address) { "user@education.gov.uk" }

    before do
      User.create!(email: "another.user@education.gov.uk")
      OmniAuth.config.mock_auth[:microsoft_graph] = OmniAuth::AuthHash.new({
        info: {
          email: user_email_address
        }
      })
      OmniAuth.config.test_mode = true
    end

    it "redirects to the sign in page and shows a helpful message" do
      get "/auth/microsoft_graph/callback"

      expect(request).to redirect_to(sign_in_path)
      expect(flash.to_h.values).to include I18n.t("unknown_user.message", email_address: user_email_address)
    end
  end
end
