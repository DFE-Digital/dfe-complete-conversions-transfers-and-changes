require "rails_helper"

RSpec.feature "Users can interact with the cookies banner" do

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  context "when accessing the service" do
    scenario "displays the cookies banner" do
      visit root_path
      expect(page).to have_css(".govuk-cookie-banner")
    end
  end
end
