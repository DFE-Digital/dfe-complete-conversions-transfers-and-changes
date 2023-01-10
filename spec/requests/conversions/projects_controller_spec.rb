require "rails_helper"

RSpec.describe Conversions::ProjectsController do
  let(:user) { create(:user, :caseworker) }

  before do
    establishment = build(:academies_api_establishment, name: "Converting School")
    trust = build(:academies_api_trust, original_name: "Convertor trust")

    mock_successful_api_calls(establishment: establishment, trust: trust)
    sign_in_with(user)
  end

  describe "#index" do
    it "lists conversion projects" do
      conversion_project = create(:conversion_project, caseworker: user)

      get conversions_path

      expect(response.body).to include(conversion_project.establishment.name)
    end
  end
end
