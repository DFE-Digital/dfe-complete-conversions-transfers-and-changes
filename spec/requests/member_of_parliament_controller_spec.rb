require "rails_helper"

RSpec.describe MemberOfParliamentController, type: :request do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, assigned_to: user) }
  let(:member_name) { build(:members_api_name) }
  let(:member_parliamentary_office) { build(:members_api_contact_details) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
  end

  describe "#show" do
    subject(:perform_request) do
      get project_mp_path(project.id)
      response
    end

    context "when the Member of Parliament is found" do
      before do
        mock_successful_members_api_responses(member_name: member_name, member_contact_details: member_parliamentary_office)
        perform_request
      end

      subject { response.body }

      it "returns the MP's name" do
        expect(subject).to include(member_name.name_full_title)
      end

      it "returns the MP's address formatted correctly" do
        expect(subject).to include("#{member_parliamentary_office.line1}<br/>#{member_parliamentary_office.line2}<br/>#{member_parliamentary_office.postcode}")
      end

      it "returns the MP's email address as a mailto link" do
        expect(subject).to include('<a href="mailto:jane.smith.mp@parliament.uk">jane.smith.mp@parliament.uk</a>')
      end
    end

    context "when the constituency search returns multiple results" do
      before do
        mock_members_api_multiple_constituencies_response
        perform_request
      end

      subject { response.body }

      it "returns a specific multiple results error page" do
        expect(subject).to include(I18n.t("pages.members_api_multiple_results_error.body_text"))
      end
    end

    context "when the Member of Parliament is not found" do
      before do
        mock_successful_constituency_search_response
        mock_successful_member_id_response
        mock_member_not_found_response
        mock_contact_details_not_found_response
        perform_request
      end

      subject { response.body }

      it "returns a 404 not found response" do
        expect(subject).to include("not found")
      end
    end

    context "when the Members Api is not responding" do
      before do
        mock_members_api_unavailable_response
        perform_request
      end

      subject { response.body }

      it "returns a 500 error page" do
        expect(subject).to include(I18n.t("pages.members_api_client_error.body_text"))
      end
    end
  end
end
