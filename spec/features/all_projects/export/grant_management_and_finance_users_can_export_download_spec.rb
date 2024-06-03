require "rails_helper"

RSpec.feature "Grant management and finance unit users can export projects by Advisory board date" do
  before do
    user = create(:user)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "transfers" do
    scenario "they can view the last year in months" do
      visit all_export_by_advisory_board_date_transfers_projects_path

      expect(page).to have_content(Date.today.to_fs(:govuk_month))
      expect(page).to have_content((Date.today - 1.month).to_fs(:govuk_month))
      expect(page).to have_content((Date.today - 11.months).to_fs(:govuk_month))
    end

    scenario "they can see the counts for each month" do
      _this_month_project = create(:transfer_project, advisory_board_date: Date.today.at_beginning_of_month, significant_date_provisional: false)
      _last_month_project = create(:transfer_project, advisory_board_date: (Date.today - 1.month).at_beginning_of_month, significant_date_provisional: false)

      visit all_export_by_advisory_board_date_transfers_projects_path

      this_month_row = page.find("##{Date.today.at_beginning_of_month.to_fs(:govuk_month).tr(" ", "_")}")
      expect(this_month_row).to have_css("td.govuk-table__cell", text: "1")

      last_month_row = page.find("##{(Date.today - 1.month).at_beginning_of_month.to_fs(:govuk_month).tr(" ", "_")}")
      expect(last_month_row).to have_css("td.govuk-table__cell", text: "1")
    end

    scenario "they can download a CSV for each month of the last year" do
      visit all_export_by_advisory_board_date_transfers_projects_path

      expect(page).to have_link("Export for #{Date.today.to_fs(:govuk_month)}")
      expect(page).to have_link("Export for #{(Date.today - 1.month).to_fs(:govuk_month)}")
      expect(page).to have_link("Export for #{(Date.today - 11.months).to_fs(:govuk_month)}")

      click_on "Export for #{Date.today.to_fs(:govuk_month)}"
      expect(page).to have_content("#{Date.today.to_fs(:govuk_month)} Grants Management and Finance Unit export")

      click_on "Download CSV file"
      expect(page.response_headers["Content-Disposition"]).to include("#{Date.today.year}-#{Date.today.month}_grant_management_and_finance_unit_transfers_export.csv")
    end
  end
end
