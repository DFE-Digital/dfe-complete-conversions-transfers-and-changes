require "rails_helper"

RSpec.describe All::Handover::HandoversController, type: :request do
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

    context "with an invalid project UUID" do
      it "returns not found" do
        get "/projects/all/handover/NOT-A-UUID/check"

        expect(response).to have_http_status(404)
      end
    end
  end

  describe "#create" do
    context "when the form is invalid" do
      let!(:project) { create(:conversion_project) }

      it "renders the form with errors" do
        post "/projects/all/handover/#{project.id}/new", params: invalid_params

        expect(response).to render_template("all/handover/projects/conversion/new")
        expect(response.body).to include("There is a problem")
      end
    end
  end

  describe "#assign" do
    context "when the form is invalid" do
      let!(:project) { create(:conversion_project) }

      it "renders the form with errors" do
        post "/projects/all/handover/#{project.id}/assign", params: invalid_params

        expect(response).to render_template("all/handover/projects/assign")
        expect(response.body).to include("There is a problem")
      end
    end
  end

  def valid_params
    {
      new_handover_stepped_form: {
        assigned_to_regional_caseworker_team: false,
        handover_note_body: "Handover note.",
        establishment_sharepoint_link: "https://educationgovuk.sharepoint.com/establishment",
        incoming_trust_sharepoint_link: "https://educationgovuk.sharepoint.com/incoming-trust",
        outgoing_trust_sharepoint_link: "https://educationgovuk.sharepoint.com/outgoing-trust",
        two_requires_improvement: true,
        email: "test.user@education.gov.uk",
        team: :west_midlands
      }
    }
  end

  def invalid_params
    {
      new_handover_stepped_form: {
        assigned_to_regional_caseworker_team: nil,
        handover_note_body: nil,
        establishment_sharepoint_link: nil,
        incoming_trust_sharepoint_link: nil,
        outgoing_trust_sharepoint_link: nil,
        two_requires_improvement: nil,
        email: nil,
        team: nil
      }
    }
  end
end
