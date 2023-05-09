require "rails_helper"

RSpec.feature "Users can delete a local authority" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker) }
  let!(:local_authority) { create(:local_authority) }

  scenario "the local authority is successfully destroyed" do
    local_authority_id = local_authority.id

    visit local_authority_path(local_authority)
    click_on "Delete"

    expect(page).to have_content "Are you sure you want to delete the record for #{local_authority.name}?"
    click_on "Delete"

    expect(page).to have_content("Local authority deleted successfully")
    expect { LocalAuthority.find(local_authority_id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
