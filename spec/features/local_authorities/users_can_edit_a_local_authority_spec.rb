require "rails_helper"

RSpec.feature "Users can edit a local authority" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let!(:local_authority) { create(:local_authority, address_1: "1 Town Square") }

  context "when the user is a caseworker" do
    let(:user) { create(:user, :caseworker) }

    scenario "the user cannot edit a local authority" do
      visit local_authority_path(local_authority)

      expect(page).to_not have_content("Edit")
    end
  end

  context "when the user is a service_support user" do
    let(:user) { create(:user, :service_support) }

    context "when the edits to the local authority are valid" do
      scenario "the local authority is successfully updated" do
        visit local_authority_path(local_authority)

        click_on "Edit"

        expect(page).to have_content("Change details for #{local_authority.name}")
        fill_in "Address line 1", with: "2 Town Square"
        click_button "Save and return"

        expect(page).to have_content "Local authority details updated"
        expect(page).to have_content "2 Town Square"
      end
    end

    context "when there are errors" do
      scenario "the form shows error messages" do
        visit local_authority_path(local_authority)

        click_on "Edit"

        expect(page).to have_content("Change details for #{local_authority.name}")
        fill_in "Address line 1", with: ""
        fill_in "Postcode", with: "XX2 9"
        click_button "Save and return"

        expect(page).to have_content "can't be blank"
        expect(page).to have_content "not recognised as a UK postcode"
      end
    end
  end
end
