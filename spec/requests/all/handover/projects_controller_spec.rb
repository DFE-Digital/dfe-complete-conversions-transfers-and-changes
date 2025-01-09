require "rails_helper"

RSpec.describe All::Handover::ProjectsController, type: :request do
  before do
    Project.destroy_all
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
      before do
        create(:transfer_project, :inactive, urn: 123456)
        create(:conversion_project, :inactive, urn: 165432)
      end

      it "shows a table of the projects" do
        get "/projects/all/handover/"

        expect(response.body).to include "123456"
        expect(response.body).to include "165432"
      end
    end

    context "when the user is not a regional delivery officer" do
      it "does not show the handover navigation item" do
        user = create(:regional_casework_services_user)
        sign_in_with(user)

        get "/projects/all"

        expect(response.body).not_to include(all_handover_projects_path)
      end
    end
  end
end
