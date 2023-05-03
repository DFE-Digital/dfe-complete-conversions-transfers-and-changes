require "rails_helper"

RSpec.feature "Users can create new voluntary conversion projects" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    sign_in_with_user(regional_delivery_officer)
    visit new_conversions_voluntary_project_path
  end

  context "when the URN and UKPRN are valid" do
    let(:urn) { 123456 }
    let(:ukprn) { 10061021 }
    let(:two_weeks_ago) { Date.today - 2.weeks }

    before { mock_successful_api_responses(urn: urn, ukprn: ukprn) }

    scenario "a new project is created" do
      fill_in_form

      click_button("Continue")

      expect(page).to have_content(I18n.t("project.show.title"))
      expect(page).to have_content("Project kick-off")
      expect(page).to have_content("Handover with regional delivery officer")

      click_on("Project information")

      expect(page).to have_content(two_weeks_ago.to_formatted_s(:govuk))
    end

    context "when the regional delivery officer is keeping the project" do
      it "shows an appropriate message" do
        fill_in_form
        within("#assigned-to-regional-caseworker-team") do
          choose("No")
        end
        click_button("Continue")

        expect(page).to have_content("Project created")
        expect(page).to have_content("You should add any contact details you have for the school, trust, solicitors, local authority and diocese (if applicable).")
      end
    end

    context "when the regional delivery officer is handing the project over to someone else" do
      it "shows the project created standalone page" do
        fill_in_form
        within("#assigned-to-regional-caseworker-team") do
          choose("Yes")
        end
        click_button("Continue")

        project = Project.last

        expect(page).to have_content("You have created a project for #{project.establishment.name}, URN #{project.urn}.")
        expect(page).to have_content("Another person will be assigned to this project.")
        expect(page).to have_link("Return to project list", href: in_progress_user_projects_path)
      end

      it "does not assign the user to the project" do
        fill_in_form
        within("#assigned-to-regional-caseworker-team") do
          choose("Yes")
        end
        click_button("Continue")

        project = Project.last
        expect(project.assigned_to).to be_nil
        expect(project.assigned_at).to be_nil
      end
    end

    scenario "there is an option to assign the project to the Regional Caseworker Team" do
      expect(page).to have_content(I18n.t("helpers.hint.conversion_project.assigned_to_regional_caseworker_team"))
    end
  end

  def fill_in_form
    fill_in "School URN", with: urn
    fill_in "Incoming trust UKPRN (UK Provider Reference Number)", with: ukprn

    within("#provisional-conversion-date") do
      completion_date = Date.today + 1.year
      fill_in "Month", with: completion_date.month
      fill_in "Year", with: completion_date.year
    end

    fill_in "School SharePoint link", with: "https://educationgovuk-my.sharepoint.com/school-folder"
    fill_in "Trust SharePoint link", with: "https://educationgovuk-my.sharepoint.com/trust-folder"

    within("#advisory-board-date") do
      fill_in "Day", with: two_weeks_ago.day
      fill_in "Month", with: two_weeks_ago.month
      fill_in "Year", with: two_weeks_ago.year
    end

    fill_in "Advisory board conditions", with: "This school must:\n1. Do this\n2. And that"

    fill_in "Handover comments", with: "A new handover comment"
    within("#assigned-to-regional-caseworker-team") do
      choose("No")
    end
    within("#directive-academy-order") do
      choose "Academy order"
    end
  end
end
