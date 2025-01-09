require "rails_helper"

RSpec.describe ProjectInformationController, type: :request do
  let(:user) { create(:user, :team_leader) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: any_args, ukprn: 10061021)
  end

  describe "#show" do
    let(:project) { create(:conversion_project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_information_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(perform_request).to have_http_status :success
    end
  end

  context "when the trust has no companies house number" do
    it "renders nothing" do
      trust = build(:academies_api_trust, companies_house_number: nil)
      project = create(:conversion_project)
      allow_any_instance_of(Project).to receive(:incoming_trust).and_return(trust)

      expect { get project_information_path(project) }.not_to raise_error
    end
  end
end
