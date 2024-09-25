require "rails_helper"

RSpec.feature "Users can view local authority details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }
  let(:local_authority) { create(:local_authority) }

  context "when the local authority is found" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
      sign_in_with_user(user)
      visit project_information_path(project)
    end

    scenario "they can view the name" do
      within("#projectDetails") do
        expect(page).to have_content(project.establishment.local_authority_name)
      end
    end
  end

  context "when the local authority is not found" do
    let(:local_authority) { nil }

    before do
      mock_academies_api_trust_success(ukprn: any_args)

      establishment = build(:academies_api_establishment)
      fake_result = Api::AcademiesApi::Client::Result.new(establishment, nil)
      test_client = Api::AcademiesApi::Client.new

      allow(establishment).to receive(:local_authority).and_return(nil)
      allow(test_client).to receive(:get_establishment).with(any_args).and_return(fake_result)
      allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)

      sign_in_with_user(user)
      visit project_information_path(project)
    end

    scenario "they can view the name (from the establishment)" do
      within("#projectDetails") do
        expect(page).to have_content(project.establishment.local_authority_name)
      end
    end
  end
end
