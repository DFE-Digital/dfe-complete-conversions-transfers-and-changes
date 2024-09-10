require "rails_helper"

RSpec.describe All::Export::BySignificantDate::Conversions::AllData::ProjectsController, type: :request do
  let(:user) { create(:user, team: :data_consumers) }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "#date_range_csv" do
    it "redirects the user if the 'from' date is after the 'to' date" do
      get "/projects/all/export/by-significant-date/conversions/all-data/from/4/2024/to/3/2024/csv"

      follow_redirect!

      expect(response.body).to include("The 'from' date cannot be after the 'to' date")
    end
  end
end
