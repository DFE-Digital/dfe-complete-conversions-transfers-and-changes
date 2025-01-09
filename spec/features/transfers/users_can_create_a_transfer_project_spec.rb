require "rails_helper"

RSpec.feature "Users can create new transfer projects" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  context "single transferer projects" do
    before do
      Project.destroy_all
      sign_in_with_user(regional_delivery_officer)
      visit transfers_new_path
    end

    context "when the URN and UKPRN are valid" do
      let(:urn) { 123456 }
      let(:incoming_ukprn) { 10061021 }
      let(:outgoing_ukprn) { 10090252 }
      let(:new_trust_reference_number) { nil }

      before {
        local_authority = LocalAuthority.new(id: "f0e04a51-3711-4d58-942a-dcb84938c818")
        establishment = build(:academies_api_establishment, diocese_code: "0000")
        allow(establishment).to receive(:local_authority).and_return(local_authority)
        mock_all_academies_api_responses(establishment: establishment)
      }

      scenario "a new project is created" do
        visit new_project_path
        choose "Transfer"
        click_button "Continue"

        fill_in_new_transfer_project_form(urn, incoming_ukprn, outgoing_ukprn)

        click_button("Continue")

        expect(page).to have_content(I18n.t("transfer_project.created.success"))
        expect(Transfer::Project.count).to eq(1)
      end
    end

    context "when required values are not supplied" do
      scenario "error messages are shown to the user" do
        visit new_project_path
        choose "Transfer"

        click_button "Continue"

        click_button("Continue")

        expect(page).to have_content("There is a problem")
      end
    end
  end

  context "form a MAT transfer projects" do
    before do
      Project.destroy_all
      sign_in_with_user(regional_delivery_officer)
      visit transfers_new_mat_path
    end

    context "when the URN, UKPRN and new Trust reference number are valid" do
      let(:urn) { 123456 }
      let(:outgoing_ukprn) { 10090252 }
      let(:incoming_ukprn) { nil }

      before {
        local_authority = LocalAuthority.new(id: "f0e04a51-3711-4d58-942a-dcb84938c818")
        establishment = build(:academies_api_establishment, diocese_code: "0000")
        allow(establishment).to receive(:local_authority).and_return(local_authority)
        mock_all_academies_api_responses(establishment: establishment)
      }

      scenario "a new project is created" do
        visit new_project_path
        choose "Form a MAT transfer"
        click_button "Continue"

        fill_in_new_transfer_project_form(urn, nil, outgoing_ukprn)
        fill_in "Trust reference number (TRN)", with: "TR12345"
        fill_in "Trust name", with: "New Trust Name"

        click_button("Continue")

        expect(page).to have_content(I18n.t("transfer_project.form_a_mat.created.success"))
        expect(Transfer::Project.count).to eq(1)
      end
    end

    context "when required values are not supplied" do
      scenario "error messages are shown to the user" do
        visit new_project_path
        choose "Form a MAT transfer"
        click_button "Continue"

        click_button("Continue")

        expect(page).to have_content("There is a problem")
      end
    end
  end
end
