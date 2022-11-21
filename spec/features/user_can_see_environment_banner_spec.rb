require "rails_helper"

RSpec.feature "Environment banner" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  describe "environment banner" do
    context "when SENTRY_ENV is production" do
      before { allow(ENV).to receive(:fetch).with("SENTRY_ENV").and_return("production") }

      scenario "cannot see the environment banner" do
        visit root_path
        expect(page).to_not have_css(".environment-banner")
      end
    end

    context "when SENTRY_ENV is non-production" do
      before { allow(ENV).to receive(:fetch).with("SENTRY_ENV").and_return("development") }

      scenario "can see the environment banner" do
        visit root_path
        within(".environment-banner") do
          expect(page).to have_content("DEVELOPMENT ENVIRONMENT")
        end
      end
    end
  end
end
