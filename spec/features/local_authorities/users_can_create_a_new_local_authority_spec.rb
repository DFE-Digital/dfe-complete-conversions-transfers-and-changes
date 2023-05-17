require "rails_helper"

RSpec.feature "Users can create a local authority" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  context "when the user is a caseworker" do
    let(:user) { create(:user, :caseworker) }

    scenario "the user cannot create a new local authority" do
      visit local_authorities_path

      expect(page).to_not have_content("New local authority")
    end

    scenario "the user cannot visit the new local authority page" do
      visit new_local_authority_path

      expect(page).to have_content("You are not authorised to perform this action.")
    end
  end

  context "when the user is a service_support user" do
    let(:user) { create(:user, :service_support) }

    context "when the new local authority is valid" do
      scenario "the local authority is successfully created" do
        visit local_authorities_path

        click_on "New local authority"

        fill_in "local_authority[name]", with: "Greater Bumbletown District Council"
        fill_in "local_authority[code]", with: "999"
        fill_in "local_authority[address_1]", with: "1 Bumbletown Street"
        fill_in "local_authority[address_postcode]", with: "BT1 1AA"
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

        fill_in "local_authority[name]", with: "Greater Bumbletown District Council"
        fill_in "local_authority[code]", with: "999"
        fill_in "local_authority[address_1]", with: "1 Bumbletown Street"
        fill_in "local_authority[address_postcode]", with: "BT1 1AA"
        click_on "Save and return"

        expect(page).to have_content("There is a problem")
        expect(page).to have_content("has already been taken")
      end
    end
  end
end
