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
    describe "sending 'new project to assign' email" do
      let!(:project) { create(:conversion_project) }
      let!(:team_leader) { create(:user, :team_leader) }

      let(:base_params) do
        {
          handover_note_body: "notes",
          establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/FOO.txt",
          incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/FOO.txt",
          outgoing_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/FOO.txt",
          two_requires_improvement: false
        }
      end

      context "when the project is assigned to the RCS team" do
        let(:params) { base_params.merge(assigned_to_regional_caseworker_team: true) }

        it "sends the 'new project to assign' email to the RCS team leaders" do
          post "/projects/all/handover/#{project.id}/new", params: {new_handover_form: params}

          expect(ActionMailer::MailDeliveryJob)
            .to(have_been_enqueued.on_queue("default")
                                      .with("TeamLeaderMailer", "new_conversion_project_created", "deliver_now", args: [team_leader, project]))
        end
      end

      context "when the project is NOT assigned to the RCS team" do
        let(:params) { base_params.merge(assigned_to_regional_caseworker_team: false) }

        it "does NOT send the 'new project to assign' email" do
          post "/projects/all/handover/#{project.id}/new", params: {new_handover_form: params}

          expect(ActionMailer::MailDeliveryJob)
            .not_to(have_been_enqueued.on_queue("default")
                                      .with("TeamLeaderMailer", "new_conversion_project_created", "deliver_now", args: [team_leader, project]))
        end
      end
    end

    context "when the form is invalid" do
      let!(:project) { create(:conversion_project) }

      it "renders the form with errors" do
        post "/projects/all/handover/#{project.id}/new", params: invalid_params

        expect(response).to render_template("all/handover/projects/conversion/new")
        expect(response.body).to include("There is a problem")
      end
    end
  end

  def valid_params
    {
      new_handover_form: {
        assigned_to_regional_caseworker_team: false,
        handover_note_body: "Handover note.",
        establishment_sharepoint_link: "https://educationgovuk.sharepoint.com/establishment",
        incoming_trust_sharepoint_link: "https://educationgovuk.sharepoint.com/incoming-trust",
        outgoing_trust_sharepoint_link: "https://educationgovuk.sharepoint.com/outgoing-trust",
        two_requires_improvement: true
      }
    }
  end

  def invalid_params
    {
      new_handover_form: {
        assigned_to_regional_caseworker_team: nil,
        handover_note_body: nil,
        establishment_sharepoint_link: nil,
        incoming_trust_sharepoint_link: nil,
        outgoing_trust_sharepoint_link: nil,
        two_requires_improvement: nil
      }
    }
  end
end
