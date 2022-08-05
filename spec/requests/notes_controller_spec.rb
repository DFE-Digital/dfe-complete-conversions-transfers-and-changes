require "rails_helper"

RSpec.describe NotesController, type: :request do
  let(:user) { User.create!(email: "user@education.gov.uk") }

  before do
    mock_successful_authentication(user.email)
    mock_successful_api_responses(urn: 12345, ukprn: 10061021)
    allow_any_instance_of(NotesController).to receive(:user_id).and_return(user.id)
  end

  describe "#index" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_notes_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end
end
