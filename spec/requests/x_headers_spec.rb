require "rails_helper"

RSpec.describe "X-Headers", type: :request do
  describe "X-Backend-Origin" do
    it "sets to 'ruby' to distinguish this service from the .NET service when 'dual-running'" do
      get page_path(id: "page_not_found")

      expect(response.headers.fetch("X-Backend-Origin")).to eq("ruby")
    end
  end
end
