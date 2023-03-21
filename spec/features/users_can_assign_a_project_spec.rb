require "rails_helper"

RSpec.feature "Any user can assign any other user to a project" do
  let!(:team_leader) { create(:user, team_leader: true, first_name: "Bobbie") }
  let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer, first_name: "Chris") }
  let!(:caseworker) { create(:user, :caseworker, first_name: "Alex") }

  let(:project) { create(:conversion_project) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  context "Assigning a project from the project internal contacts tab" do
    context "The user is a caseworker" do
      let(:user) { caseworker }

      scenario "The caseworker can assign another user to a project" do
        visit conversions_voluntary_project_internal_contacts_path(project_id)

        assigned_to_summary_list_row = -> { page.find("dt", text: "Assigned to").ancestor(".govuk-summary-list__row") }

        within assigned_to_summary_list_row.call do
          expect(page).to have_content "Not yet assigned"

          click_on "Change"
        end

        expect(page).to have_current_path(conversions_voluntary_project_assign_assigned_to_path(project))

        select team_leader.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: project.establishment.name)

        click_on "Continue"

        within assigned_to_summary_list_row.call do
          expect(page).to have_content team_leader.full_name
        end
      end
    end

    context "The user is a team leader" do
      let(:user) { team_leader }

      scenario "The team leader can assign another user to a project" do
        visit conversions_voluntary_project_internal_contacts_path(project_id)

        assigned_to_summary_list_row = -> { page.find("dt", text: "Assigned to").ancestor(".govuk-summary-list__row") }

        within assigned_to_summary_list_row.call do
          expect(page).to have_content "Not yet assigned"

          click_on "Change"
        end

        expect(page).to have_current_path(conversions_voluntary_project_assign_assigned_to_path(project))

        select regional_delivery_officer.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: project.establishment.name)

        click_on "Continue"

        within assigned_to_summary_list_row.call do
          expect(page).to have_content regional_delivery_officer.full_name
        end
      end
    end

    context "The user is a regional delivery officer" do
      let(:user) { regional_delivery_officer }

      scenario "The regional delivery officer can assign another user to a project" do
        visit conversions_voluntary_project_internal_contacts_path(project_id)

        assigned_to_summary_list_row = -> { page.find("dt", text: "Assigned to").ancestor(".govuk-summary-list__row") }

        within assigned_to_summary_list_row.call do
          expect(page).to have_content "Not yet assigned"

          click_on "Change"
        end

        expect(page).to have_current_path(conversions_voluntary_project_assign_assigned_to_path(project))

        select caseworker.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: project.establishment.name)

        click_on "Continue"

        within assigned_to_summary_list_row.call do
          expect(page).to have_content caseworker.full_name
        end
      end
    end
  end

  context "Assigning a project from the Unassigned projects list" do
    context "The user is a caseworker" do
      let(:user) { caseworker }

      scenario "The user cannot view the Unassigned projects list" do
        visit root_path

        expect(page).to_not have_content(I18n.t("subnavigation.unassigned_projects"))
      end
    end

    context "The user is a regional delivery officer" do
      let(:user) { regional_delivery_officer }

      scenario "The user cannot view the Unassigned projects list" do
        visit root_path

        expect(page).to_not have_content(I18n.t("subnavigation.unassigned_projects"))
      end
    end

    context "The user is a team leader" do
      let(:user) { team_leader }
      before do
        (100001..100006).each do |urn|
          mock_successful_api_responses(urn: urn, ukprn: 10061021)
        end

        allow(EstablishmentsFetcher).to receive(:new).and_return(mock_establishments_fetcher)
        allow(IncomingTrustsFetcher).to receive(:new).and_return(mock_trusts_fetcher)
      end

      let(:mock_establishments_fetcher) { double(EstablishmentsFetcher, call: true) }
      let(:mock_trusts_fetcher) { double(IncomingTrustsFetcher, call: true) }

      let!(:unassigned_project) {
        create(
          :conversion_project,
          urn: 100001,
          assigned_to: nil,
          assigned_to_regional_caseworker_team: true
        )
      }

      scenario "The user can assign another user to an unassigned project, and is redirected to the Unassigned projects list" do
        visit root_path

        click_on "Unassigned projects"
        expect(page).to have_content("100001")

        click_on "Assign"
        expect(page).to have_current_path(conversions_voluntary_project_assign_assigned_to_path(unassigned_project))

        select caseworker.full_name, from: I18n.t("assignment.assign_assigned_to.title", school_name: unassigned_project.establishment.name)

        click_on "Continue"
        expect(page).to have_current_path(unassigned_regional_casework_services_projects_path)

        # The project is assigned and therefore does not appear on this page any more
        expect(page).to_not have_css("span", text: "URN 100001")
      end
    end
  end
end
