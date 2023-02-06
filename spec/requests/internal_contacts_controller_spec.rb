require "rails_helper"

RSpec.describe AssignmentsController, type: :request do
  let(:user) { create(:user, team_leader: true) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  describe "#show" do
    let(:project) { create(:voluntary_conversion_project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_internal_contacts_path(project_id)
      response
    end

    describe "links to assign users to project roles" do
      let(:change_links) do
        [
          project_assign_team_lead_path(project),
          project_assign_regional_delivery_officer_path(project),
          project_assign_caseworker_path(project)
        ]
      end

      before { perform_request }

      subject { response.body }

      context "when team leader" do
        it "has change links" do
          expect(subject).to include(*change_links)
        end
      end

      context "when regional delivery officer" do
        let(:user) { create(:user, :regional_delivery_officer) }

        it "does not have change links" do
          expect(subject).to_not include(*change_links)
        end
      end

      context "when caseworker" do
        let(:user) { create(:user, :caseworker) }

        it "does not have change links" do
          expect(subject).to_not include(*change_links)
        end
      end
    end
  end
end
