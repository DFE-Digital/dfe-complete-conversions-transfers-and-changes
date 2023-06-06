require "rails_helper"

RSpec.feature "All new conversion projects have a locale file & all keys are present" do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  context "voluntary projects" do
    it "have locales when creating a new project" do
      visit conversions_new_path

      expect(page).to_not have_css(".translation_missing")
    end
  end
end
