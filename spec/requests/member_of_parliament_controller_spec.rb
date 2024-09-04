require "rails_helper"

RSpec.describe MemberOfParliamentController, type: :request do
  before do
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, assigned_to: user) }

  describe "#show" do
    context "when the Member of Parliament is found" do
      before do
        test_successful_persons_api_call
      end

      it "includes the members details" do
        get project_mp_path(project)

        expect(response.body).to include("First Last")
        expect(response.body).to include("lastf@parliament.gov.uk")
      end
    end

    context "when the Member of Parliament is not found" do
      before { test_failed_persons_api_call }

      it "shows a message with the constituency name" do
        allow(project.establishment).to receive(:parliamentary_constituency).and_return("East Ham")

        get project_mp_path(project)

        expect(response.body).to include "MP Could not be found on the DfE Persons API for constituency"
        expect(response.body).to include project.establishment.parliamentary_constituency
      end
    end
  end
end

def test_successful_persons_api_call
  client = Api::Persons::Client.new
  member = Api::Persons::MemberDetails.new({
    firstName: "First",
    lastName: "Last",
    email: "lastf@parliament.gov.uk"
  }.with_indifferent_access)

  allow(client).to receive(:member_for_constituency).and_return(Api::Persons::Client::Result.new(member, nil))
  allow(Api::Persons::Client).to receive(:new).and_return(client)
end

def test_failed_persons_api_call
  client = Api::Persons::Client.new

  allow(client).to receive(:member_for_constituency).and_return(Api::Persons::Client::Result.new(nil, Api::Persons::Client::Error.new))
  allow(Api::Persons::Client).to receive(:new).and_return(client)
end
