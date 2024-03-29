require "rails_helper"

RSpec.feature "Users can view local authorities" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let!(:local_authority_1) { create(:local_authority, code: 100) }
  let!(:local_authority_2) { create(:local_authority, code: 101) }

  let(:user) { create(:user, :caseworker) }

  scenario "they can view all local authorities" do
    visit local_authorities_path

    expect(page).to have_content("Local authorities")
    expect(page).to have_content(local_authority_1.name)
    expect(page).to have_content(local_authority_2.name)
  end

  scenario "they can view an individual local authority" do
    visit local_authority_path(local_authority_1)

    expect(page).to have_content(local_authority_1.name)
  end

  context "when the user is a service_support user" do
    let(:user) { create(:user, :service_support) }

    scenario "they can add a new local authority" do
      visit local_authorities_path

      expect(page).to have_content("New local authority")
    end

    scenario "they can edit or delete a local authority" do
      visit local_authority_path(local_authority_1)

      expect(page).to have_content("Edit")
      expect(page).to have_content("Delete")
    end
  end
end
