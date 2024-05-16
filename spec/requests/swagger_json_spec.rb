require "rails_helper"

RSpec.describe "Swagger json" do
  before do
    get "/api/swagger.json"
  end

  it "includes the title" do
    result = JSON.parse(response.body)

    expect(result.dig("info", "title")).to include "Complete conversions, transfers and changes"
  end

  it "includes the description" do
    result = JSON.parse(response.body)

    expect(result.dig("info", "description")).to include "complete conversions, transfers and changes"
  end

  it "includes the support email" do
    result = JSON.parse(response.body)

    expect(result.dig("info", "contact", "email")).to include "regionalservices.rg@education.gov.uk"
  end

  it "includes the host" do
    result = JSON.parse(response.body)

    expect(result.dig("host")).to include "www.example.com"
  end
end
