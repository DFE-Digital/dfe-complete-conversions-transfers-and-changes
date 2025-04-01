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

  context "when a very long path is supplied in an attack" do
    it "is handled without an Errno::ENAMETOOLONG error" do
      very_long_path = "/%2525c0%2525ae%2525c0%2525ae%2525c0%2525af%2525c0%2525ae%2525c0%2525ae%2525c0%2525af%2525c0%2525ae%2525c0%2525ae%2525c0%2525af%2525c0%2525ae%2525c0%2525ae%2525c0%2525af%2525c0%2525ae%2525c0%2525ae%2525c0%2525af%2525c0%2525ae%2525c0%2525ae%2525c0%2525af%2525c0%2525ae%2525c0%2525ae%2525c0%2525af%2525c0%2525ae%2525c0%2525ae%2525c0%2525af/etc/passwd"

      get very_long_path

      expect(response).to redirect_to(sign_in_path)
    end
  end

  context "when the hex code '%ff' (�) is received" do
    it "is handled without an ActionController::BadRequest error" do
      hex_code = "/%ff"

      get hex_code

      expect(response).to redirect_to(sign_in_path)
    end
  end

  context "when an invalid query string is received" do
    it "is handled without an ActionController::BadRequest error" do
      invalid_query_string = "x=&x%5B%5D=a"

      get "/users/sign_in?#{invalid_query_string}"

      expect(response).to redirect_to(sign_in_path)
    end
  end

  context "when a page number which is out of range is requested" do
    before { sign_in_with(create(:user)) }

    it "is handled as '404 Not Found' without a Pagy::OverflowError" do
      get "/projects/all/trusts?page=999"

      expect(response).to render_template("pages/page_not_found", status: :not_found)
    end
  end
end
