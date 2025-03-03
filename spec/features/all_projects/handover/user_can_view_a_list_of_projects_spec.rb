require "rails_helper"

RSpec.feature "Users can view a list of handover projects" do
  before do
    user = create(:regional_delivery_officer_user)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "as a table" do
    conversion_project = create(:conversion_project, state: :inactive, urn: 123456, conversion_date: Date.new(2024, 2, 1))
    transfer_project = create(:transfer_project, state: :inactive, urn: 165432, transfer_date: Date.new(2024, 1, 1))

    visit root_path
    click_link "All projects"
    click_link "Handover"

    expect(page).to have_content("Projects to handover")
    expect(page).to have_content("These projects have been worked on in Prepare")

    within("tbody tr:first-of-type") do
      expect(page).to have_content(transfer_project.urn)
    end

    within("tbody tr:last-of-type") do
      expect(page).to have_content(conversion_project.urn)
    end
  end

  context "finding a particular inactive project" do
    let(:max_projects_per_page) { Pagy::DEFAULT.fetch(:items) }

    before do
      max_projects_per_page.times { create(:conversion_project, state: :inactive) }
    end

    context "when all the _inactive_ projects can be shown on a single page" do
      before do
        visit root_path
        click_link "All projects"
        click_link "Handover"
      end

      scenario "there's no need to search for a particular _inactive_ project" do
        expect(page).to_not have_content("Search for project to be handed over")
      end
    end

    context "when NOT all the _inactive_ projects can be shown on a single page" do
      let!(:target_project) { create(:conversion_project, state: :inactive, urn: 919191) }

      let!(:active_project) { create(:conversion_project, state: :active, urn: 666333) }

      before do
        visit root_path
        click_link "All projects"
        click_link "Handover"
      end

      scenario "it's possible to search for a particular _inactive_ project" do
        then_i_have_a_way_to_find_a_particular_inactive_project

        when_i_search_for_a_particular_project_which_exists
        then_i_find_that_particular_project
        and_use_the_link_to_add_handover_details

        when_i_search_for_a_particular_project_which_does_not_exist
        then_i_see_a_helpful_message_and_can_search_again
      end
    end

    def then_i_have_a_way_to_find_a_particular_inactive_project
      expect(page).to have_field("Search for project to be handed over")
    end

    def when_i_search_for_a_particular_project_which_exists
      within ".dfe-body__search" do
        fill_in("Search by URN", with: target_project.urn)
        click_button("Search")
      end
    end

    def then_i_find_that_particular_project
      expect(page).to have_content("A project to be handed over with URN #{target_project.urn} was found")
      expect(page).to have_content(target_project.establishment.name)
      expect(page).to_not have_content("Search for project to be handed over")
    end

    def and_use_the_link_to_add_handover_details
      expect(page).to have_link("Add handover details", href: check_all_handover_projects_path(target_project))
    end

    def when_i_search_for_a_particular_project_which_does_not_exist
      click_link "Handover"
      within ".dfe-body__search" do
        expect(page).to have_content("Search for project to be handed over")
        fill_in("Search by URN", with: active_project.urn)
        click_button("Search")
      end
    end

    def then_i_see_a_helpful_message_and_can_search_again
      expect(page).to have_content("No project to be handed over with URN #{active_project.urn} was found")
      expect(page).to have_content("Search for project to be handed over")
    end
  end
end
