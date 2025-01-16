require "rails_helper"

RSpec.describe "Error handling", type: :request do
  context "when a valid authenticity token isn't supplied" do
    describe "DELETE to #server-status (or other bogus resource)" do
      before do
        ActionController::Base.allow_forgery_protection = true
      end
      after do
        ActionController::Base.allow_forgery_protection = false
      end

      it "resets any session cookie, via the sign out mechanism" do
        delete "/server-status"
        expect(response).to redirect_to(sign_out_path)
      end
    end
  end
end
