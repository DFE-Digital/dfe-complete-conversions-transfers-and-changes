require "rails_helper"

RSpec.feature "Grant management and finance unit users can export projects by Advisory board date" do
  scenario "they can view the last year in months" do
    user = create(:user)
    sign_in_with_user(user)
    visit all_export_grant_management_and_finance_unit_conversions_projects_path

    expect(page).to have_content(Date.today.to_fs(:govuk_month))
    expect(page).to have_content((Date.today - 1.month).to_fs(:govuk_month))
    expect(page).to have_content((Date.today - 11.months).to_fs(:govuk_month))
  end

  scenario "they can download a CSV for each month of the last year" do
    user = create(:user)
    sign_in_with_user(user)
    visit all_export_grant_management_and_finance_unit_conversions_projects_path

    expect(page).to have_link("Export for #{Date.today.to_fs(:govuk_month)}")
    expect(page).to have_link("Export for #{(Date.today - 1.month).to_fs(:govuk_month)}")
    expect(page).to have_link("Export for #{(Date.today - 11.months).to_fs(:govuk_month)}")

    click_on "Export for #{Date.today.to_fs(:govuk_month)}"
    expect(page.response_headers["Content-Disposition"]).to include("#{Date.today.year}-#{Date.today.month}_grant_management_and_finance_unit_conversions_export.csv")
  end
end
