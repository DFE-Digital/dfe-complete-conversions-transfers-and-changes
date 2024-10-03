require "rails_helper"

RSpec.describe All::Handover::ProjectsController, type: :request do
  before do
    user = create(:regional_delivery_officer_user)
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  describe "#index" do
    context "when there are no projects to hand over" do
      it "shows a helpful message" do
        get "/projects/all/handover/"

        expect(response.body).to include("There are no projects to handover")
      end
    end

    context "when there are projects" do
      let!(:project) { create(:transfer_project, :inactive, urn: 123456) }
      let!(:project) { create(:conversion_project, :inactive, urn: 165432) }

      it "shows a table of the projects" do
        create(:transfer_project, :inactive, urn: 123456)
        create(:conversion_project, :inactive, urn: 165432)

        get "/projects/all/handover/"

        expect(response.body).to include "123456"
        expect(response.body).to include "165432"
      end
    end
  end
end
