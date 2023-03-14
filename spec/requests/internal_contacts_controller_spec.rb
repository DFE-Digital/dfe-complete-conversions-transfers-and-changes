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
      get conversions_voluntary_project_internal_contacts_path(project_id)
      response
    end

    describe "links to assign users to project roles" do
      before { perform_request }

      subject { response.body }

      context "when team leader" do
        it "has regional delivery officer and assign_to links" do
          expect(subject).to include(project_assign_regional_delivery_officer_path(project))
          expect(subject).to include(project_assign_assigned_to_path(project))
        end
      end

      context "when regional delivery officer" do
        let(:user) { create(:user, :regional_delivery_officer) }

        it "does not have regional delivery officer link but does have assign_to link" do
          expect(subject).to_not include(project_assign_regional_delivery_officer_path(project))
          expect(subject).to include(project_assign_assigned_to_path(project))
        end
      end

      context "when caseworker" do
        let(:user) { create(:user, :caseworker) }

        it "does not have regional delivery officer link but does have assign_to link" do
          expect(subject).to_not include(project_assign_regional_delivery_officer_path(project))
          expect(subject).to include(project_assign_assigned_to_path(project))
        end
      end
    end
  end
end
