require "rails_helper"

RSpec.feature "Viewing projects with a revised conversion date" do
  scenario "Users can view the projects that were due to convert for a given month and year" do
    user = create(:user)

    sign_in_with_user(user)
    mock_successful_api_response_to_create_any_project

    project_with_confirmed_date = create(:conversion_project, assigned_to: user, conversion_date_provisional: false, urn: 121813)
    create(:date_history, project: project_with_confirmed_date, previous_date: Date.today.at_beginning_of_month, revised_date: Date.today.at_beginning_of_month)

    project_with_other_date = create(:conversion_project, assigned_to: user, conversion_date_provisional: false, urn: 121102)
    create(:date_history, project: project_with_other_date, previous_date: Date.today.at_beginning_of_month + 1.month, revised_date: Date.today.at_beginning_of_month + 4.months)

    project_with_matching_date = create(:conversion_project, assigned_to: user, conversion_date_provisional: false, urn: 101133)
    create(:date_history, project: project_with_matching_date, previous_date: Date.today.at_beginning_of_month, revised_date: Date.today.at_beginning_of_month + 3.months)
    create(:date_history, project: project_with_matching_date, previous_date: Date.today.at_beginning_of_month + 3.months, revised_date: Date.today.at_beginning_of_month + 4.months)

    visit "/projects/all/opening/revised/#{(Date.today + 3.months).month}/#{(Date.today + 3.months).year}"

    expect(page).to have_content I18n.t("project.revised_conversion_date.title", date: (Date.today + 3.months).to_fs(:govuk_month))
    expect(page).to have_content project_with_matching_date.urn
    expect(page).not_to have_content project_with_confirmed_date.urn
    expect(page).not_to have_content project_with_other_date.urn
  end
end
