require "rails_helper"

RSpec.feature "Users change the assigned user", driver: :headless_firefox do
  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  after do
    sign_out
    # we need to wait after signing out otherwise we get flaking sessions
    sleep(0.5)
  end

  let(:project) { create(:conversion_project, assigned_to: user) }

  context "when they are a caseworker" do
    let(:user) { create(:user, :caseworker) }

    scenario "by navigating to a project" do
      other_user = create(:user, :caseworker, email: "other.user@education.gov.uk")

      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end
      fill_in "Assign to", with: other_user.email

      within("ul.autocomplete__menu") do
        expect(page).to have_content("#{other_user.first_name} #{other_user.last_name} (#{other_user.email})")
        find("li.autocomplete__option").click
      end
      click_button "Continue"

      expect(page).to have_content("Project has been assigned successfully")
      expect(page).to have_content("Not assigned to project")
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        expect(page).to have_content(other_user.first_name)
      end
    end
  end

  context "when they are a team leader" do
    let(:user) { create(:user, :team_leader) }

    scenario "by navigating to a project" do
      other_user = create(:user, :caseworker, email: "other.user@education.gov.uk")

      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end
      fill_in "Assign to", with: other_user.email

      within("ul.autocomplete__menu") do
        expect(page).to have_content("#{other_user.first_name} #{other_user.last_name} (#{other_user.email})")
        find("li.autocomplete__option").click
      end
      click_button "Continue"

      expect(page).to have_content("Project has been assigned successfully")
      expect(page).to have_content("Not assigned to project")
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        expect(page).to have_content(other_user.first_name)
      end
    end
  end

  describe "autocompletion" do
    let(:user) do
      create(
        :user,
        :caseworker,
        first_name: "Regional",
        last_name: "Caseworker",
        email: "regional.caseworker@education.gov.uk"
      )
    end

    it "shows the current user" do
      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end

      autocomplete_value = find_field("user-autocomplete").value

      expect(autocomplete_value).to have_content("#{user.first_name} #{user.last_name} (#{user.email})")
    end

    it "searches by first name" do
      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end

      fill_in "Assign to", with: user.first_name

      within(autocomplete_first_suggestion) do
        expect(page).to have_content("#{user.first_name} #{user.last_name} (#{user.email})")
      end
    end

    it "searches by last name" do
      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end

      fill_in "Assign to", with: user.last_name

      within(autocomplete_first_suggestion) do
        expect(page).to have_content("#{user.first_name} #{user.last_name} (#{user.email})")
      end
    end

    it "searches by email address" do
      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end

      fill_in "Assign to", with: user.email

      # give the autocomplete time to load
      sleep(0.5)

      within(autocomplete_first_suggestion) do
        expect(page).to have_content("#{user.first_name} #{user.last_name} (#{user.email})")
      end
    end

    it "shows no results found when there is no match" do
      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end

      fill_in "Assign to", with: "Jane"

      within(autocomplete_no_results) do
        expect(page).to have_content("No results found")
      end
    end

    it "shows nothing when the project is not assigned" do
      project = create(:conversion_project, assigned_to: nil)
      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end

      fill_in "Assign to", with: user.email

      # give the autocomplete time to load
      sleep(0.5)

      within(autocomplete_first_suggestion) do
        expect(page).to have_content("#{user.first_name} #{user.last_name} (#{user.email})")
      end
    end
  end

  def autocomplete_first_suggestion
    page.find("li#user-autocomplete__option--0")
  end

  def autocomplete_no_results
    page.find("li.autocomplete__option--no-results")
  end
end
