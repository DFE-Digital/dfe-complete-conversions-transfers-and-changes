require "rails_helper"

RSpec.describe "Sign out" do
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

    it "signs out, redirects to the sign in page and shows a helpful message" do
      get sign_out_path

      expect(session[:user_id]).to be_nil
      expect(request).to redirect_to(sign_in_path)
      expect(flash.to_h.values).to include I18n.t("sign_out.message.success")
    end
  end
end
