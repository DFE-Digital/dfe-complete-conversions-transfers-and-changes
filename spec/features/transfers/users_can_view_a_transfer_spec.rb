require "rails_helper"

RSpec.feature "Users can view a transfer" do
  before do
    user = create(:user)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:transfer_project) { create(:transfer_project) }

  scenario "via the tasks route" do
    visit project_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("Transfer")
  end
end
