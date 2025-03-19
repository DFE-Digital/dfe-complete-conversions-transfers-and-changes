require "rails_helper"

RSpec.feature "Users can handover projects" do
  before do
    user = create(:regional_delivery_officer_user)
    sign_in_with_user(user)
  end

  context "when the project is missing its #incoming_trust_ukprn" do
    def mock_trust_not_found_at_academies_api
      establishment = build(:academies_api_establishment)
      local_authority = create(:local_authority)
      allow(establishment).to receive(:local_authority).and_return(local_authority)

      establishments = build_list(:academies_api_establishment, 3)
      trusts = build_list(:academies_api_trust, 3)

      test_client = double(Api::AcademiesApi::Client,
        get_establishments: Api::AcademiesApi::Client::Result.new(establishments, nil),
        get_establishment: Api::AcademiesApi::Client::Result.new(establishment, nil),
        get_trusts: Api::AcademiesApi::Client::Result.new(trusts, nil),
        get_trust: Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("Test Academies API not found error")))

      allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
    end

    def confirm_that_this_is_the_correct_project
      click_link "Add handover details"
      click_link "Confirm"
    end

    def add_details_and_attempt_handover
      within "#assigned-to-regional-caseworker-team" do
        choose "No"
      end
      fill_in "School SharePoint link", with: "https://educationgovuk.sharepoint.com/establishment"
      fill_in "Incoming trust SharePoint link", with: "https://educationgovuk.sharepoint.com/incoming-trust"
      within "#two-requires-improvement" do
        choose "No"
      end
      click_button "Confirm"
    end

    before do
      mock_trust_not_found_at_academies_api
    end

    let!(:conversion_project) {
      build(
        :conversion_project,
        state: :inactive,
        urn: 123456,
        incoming_trust_ukprn: nil,
        new_trust_reference_number: nil,
        new_trust_name: "can't find UKPRN",
        conversion_date: Date.new(2024, 2, 1)
      ).tap { |p| p.save(validate: false) }
    }
    scenario "they see an error message explaining that the UKPRN must be added in Prepare" do
      visit all_handover_projects_path
      confirm_that_this_is_the_correct_project
      add_details_and_attempt_handover

      expect(page).to have_content(
        "This project is missing its incoming trust UKPRN so can not be handed over." \
      )
      expect(page).to have_content(
        "Service support must delete this project and fix up the project in Prepare."
      )
      expect(page).to have_content(
        "If the project is part of a Form a MAT project and no UKPRN exists you must " \
        "add a Trust reference number (TRN) instead of the incoming trust UKPRN."
      )
    end

    context "when 'Form a MAT', missing UKPRN (but has new_trust_reference_number)" do
      let!(:conversion_project) {
        build(
          :conversion_project,
          state: :inactive,
          urn: 123456,
          incoming_trust_ukprn: nil,
          new_trust_reference_number: "TR01234",
          new_trust_name: "can't find UKPRN",
          conversion_date: Date.new(2024, 2, 1)
        ).tap { |p| p.save(validate: false) }
      }
      scenario "they see NO error" do
        visit all_handover_projects_path
        confirm_that_this_is_the_correct_project
        add_details_and_attempt_handover

        expect(page).not_to have_content(
          "This project is missing its incoming trust UKPRN so can not be handed over."
        )
        expect(page).to have_content(
          "Project assigned"
        )
      end
    end
  end

  context "when the project is a conversion" do
    before { mock_all_academies_api_responses }

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
    before { mock_all_academies_api_responses }

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
