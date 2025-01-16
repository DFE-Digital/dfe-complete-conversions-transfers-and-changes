require "rails_helper"

RSpec.describe TestErrorController, type: :request do
  describe "GET to #create" do
    context "when authenticated" do
      before do
        sign_in_with(create(:user))
      end

      it "raises a _TestError_" do
        expect {
          get test_error_path
        }.to raise_error(TestError)
      end
    end
  end

  context "when NOT authenticated" do
    it "does NOT raise an error" do
      expect {
        get test_error_path
      }.to_not raise_error
    end
  end
end
