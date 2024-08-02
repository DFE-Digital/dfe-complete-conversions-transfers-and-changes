module ProjectHelpers
  def create_unassigned_project(urn: 123456, incoming_trust_ukprn: 12345678)
    project = build(:project, urn: urn, incoming_trust_ukprn: incoming_trust_ukprn)
    mock_successful_api_responses(urn: project.urn, ukprn: project.incoming_trust_ukprn)
    project.save!
    project
  end

  def fill_in_new_conversion_project_form(urn, ukprn)
    fill_in "School URN", with: urn
    fill_in "Incoming trust UKPRN (UK Provider Reference Number)", with: ukprn

    within("#provisional-conversion-date") do
      completion_date = Date.today + 1.year
      fill_in "Month", with: completion_date.month
      fill_in "Year", with: completion_date.year
    end

    fill_in "School or academy SharePoint link", with: "https://educationgovuk-my.sharepoint.com/school-folder"
    fill_in "Incoming trust SharePoint link", with: "https://educationgovuk-my.sharepoint.com/trust-folder"

    within("#advisory-board-date") do
      advisory_board_date = Date.today - 2.weeks
      fill_in "Day", with: advisory_board_date.day
      fill_in "Month", with: advisory_board_date.month
      fill_in "Year", with: advisory_board_date.year
    end

    fill_in "Advisory board conditions", with: "This school must:\n1. Do this\n2. And that"

    fill_in "Handover comments", with: "A new handover comment"
    within("#assigned-to-regional-caseworker-team") do
      choose("No")
    end
    within("#directive-academy-order") do
      choose "Academy order"
    end
    within("#two-requires-improvement") do
      choose "No"
    end
  end
end
