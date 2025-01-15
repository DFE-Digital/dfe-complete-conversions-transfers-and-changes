require "rails_helper"

RSpec.describe TestErrorController, type: :request do
  describe "GET to #create" do
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
