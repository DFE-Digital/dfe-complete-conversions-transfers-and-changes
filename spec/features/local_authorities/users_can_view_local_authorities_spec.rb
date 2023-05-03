require "rails_helper"

RSpec.feature "Users can view local authorities" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let!(:local_authority_1) { create(:local_authority) }
  let!(:local_authority_2) { create(:local_authority) }
  let(:user) { create(:user, :caseworker) }

  scenario "they can view all local authorities" do
    visit local_authorities_path

    expect(page).to have_content("Local Authorities")
    expect(page).to have_content(local_authority_1.name)
    expect(page).to have_content(local_authority_2.name)
  end

  scenario "they can view an individual local authority" do
    visit local_authority_path(local_authority_1)

    expect(page).to have_content(local_authority_1.name)
  end
end
