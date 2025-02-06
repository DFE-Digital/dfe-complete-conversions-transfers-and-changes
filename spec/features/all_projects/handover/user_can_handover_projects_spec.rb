require "rails_helper"

RSpec.feature "Users can handover projects" do
  before do
    Project.destroy_all
    user = create(:regional_delivery_officer_user)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when the project is a conversion" do
    let!(:conversion_project) {
      create(
        :conversion_project,
        state: :inactive, urn: 123456,
        conversion_date: Date.new(2024, 2, 1)
      )
    }

    scenario "they can check they have the right project and cancel if not" do
      visit all_handover_projects_path
      click_link "Add handover details"

      expect(page).to have_content("Check you have the right project")
      expect(page).to have_content("Conversion")
      expect(page).to have_content(conversion_project.urn)

      click_link "Choose a different project"

      expect(page).to have_content("Projects to handover")
      expect(page).to have_content("These projects have been worked on in Prepare")
    end

    context "when the conversion is a forming a MAT" do
      let!(:conversion_project) {
        create(
          :conversion_project,
          :form_a_mat,
          state: :inactive, urn: 123456,
          conversion_date: Date.new(2024, 2, 1)
        )
      }

      scenario "they can check they have the right project and cancel if not" do
        visit all_handover_projects_path
        click_link "Add handover details"

        expect(page).to have_content("Check you have the right project")
        expect(page).to have_content("Conversion")
        expect(page).to have_content(conversion_project.urn)
        expect(page).to have_content(conversion_project.new_trust_reference_number)
        expect(page).to have_content(conversion_project.new_trust_name)

        click_link "Choose a different project"

        expect(page).to have_content("Projects to handover")
        expect(page).to have_content("These projects have been worked on in Prepare")
      end
    end
  end

  context "when the project is a transfer" do
    let!(:transfer_project) {
      create(
        :transfer_project,
        state: :inactive,
        urn: 165432,
        transfer_date: Date.new(2024, 1, 1)
      )
    }

    scenario "they can check they have the right project and cancel if not" do
      visit all_handover_projects_path
      click_link "Add handover details"

      expect(page).to have_content("Check you have the right project")
      expect(page).to have_content("Transfer")
      expect(page).to have_content(transfer_project.urn)

      click_link "Choose a different project"

      expect(page).to have_content("Projects to handover")
      expect(page).to have_content("These projects have been worked on in Prepare")
    end

    context "when the transfer is a forming a MAT" do
      let!(:transfer_project) {
        create(
          :transfer_project,
          :form_a_mat,
          state: :inactive, urn: 123456,
          transfer_date: Date.new(2024, 2, 1)
        )
      }

      scenario "they can check they have the right project and cancel if not" do
        visit all_handover_projects_path
        click_link "Add handover details"

        expect(page).to have_content("Check you have the right project")
        expect(page).to have_content("Transfer")
        expect(page).to have_content(transfer_project.urn)
        expect(page).to have_content(transfer_project.new_trust_reference_number)
        expect(page).to have_content(transfer_project.new_trust_name)

        click_link "Choose a different project"

        expect(page).to have_content("Projects to handover")
        expect(page).to have_content("These projects have been worked on in Prepare")
      end
    end
  end
end
