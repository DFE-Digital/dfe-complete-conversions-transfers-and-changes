require "rails_helper"

RSpec.feature "Users can create a local authority" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker) }

  context "when the new local authority is valid" do
    scenario "the local authority is successfully created" do
      visit local_authorities_path

      click_on "New local authority"

      fill_in "Name", with: "Greater Bumbletown District Council"
      fill_in "Code", with: "999"
      fill_in "Address line 1", with: "1 Bumbletown Street"
      fill_in "Postcode", with: "BT1 1AA"
      click_on "Save and return"

      expect(page).to have_content("Local authority successfully created")
      expect(page).to have_content("Greater Bumbletown District Council")
    end
  end

  context "when there are missing required attributes" do
    scenario "the form shows error messages" do
      visit new_local_authority_path

      click_on "Save and return"

      expect(page).to have_content("There is a problem")
      expect(page).to have_content("can't be blank")
    end
  end

  context "when there is a Local authority with the same code" do
    let!(:existing_local_authority) { create(:local_authority, code: 999) }

    scenario "the form shows error messages" do
      visit new_local_authority_path

      fill_in "Name", with: "Greater Bumbletown District Council"
      fill_in "Code", with: "999"
      fill_in "Address line 1", with: "1 Bumbletown Street"
      fill_in "Postcode", with: "BT1 1AA"
      click_on "Save and return"

      expect(page).to have_content("There is a problem")
      expect(page).to have_content("has already been taken")
    end
  end
end
