require "rails_helper"

RSpec.describe All::Handover::ProjectsController, type: :request do
  before do
    user = create(:regional_delivery_officer_user)
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  describe "#check" do
    context "when the project is a conversion" do
      let!(:project) { create(:conversion_project) }

      it "renders the correct template" do
        get "/projects/all/handover/#{project.id}/check"

        expect(response).to render_template("all/handover/projects/conversion/check")
      end
    end

    context "when the project is a transfer" do
      let!(:project) { create(:transfer_project) }

      it "renders the correct template" do
        get "/projects/all/handover/#{project.id}/check"

        expect(response).to render_template("all/handover/projects/transfer/check")
      end
    end
  end
end
