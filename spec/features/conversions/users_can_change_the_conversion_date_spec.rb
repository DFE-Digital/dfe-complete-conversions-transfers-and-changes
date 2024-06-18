require "rails_helper"

RSpec.feature "Users can change the conversion date" do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  scenario "they can change the date on a conversion project and see a confirmation view" do
    revised_conversion_date = (Date.today + 6.months).at_beginning_of_month
    project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false, assigned_to: user)

    visit project_path(project)

    click_on(I18n.t("conversion_new_date_history_form.new"))

    expect(page).to have_content(I18n.t("helpers.legend.conversion_new_date_history_form.revised_date"))
    expect(page).to have_content(I18n.t("helpers.label.conversion_new_date_history_form.note_body"))

    fill_in("Month", with: revised_conversion_date.month)
    fill_in("Year", with: revised_conversion_date.year)
    fill_in(I18n.t("helpers.label.conversion_new_date_history_form.note_body"), with: "This is a test note being added.")

    click_button(I18n.t("conversion_new_date_history_form.submit"))

    expect(page).to have_content(I18n.t("conversion_new_date_history_form.success.panel.title"))
  end

  scenario "they can cancel the change if needed" do
    project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false, assigned_to: user)

    visit project_path(project)

    click_on(I18n.t("conversion_new_date_history_form.new"))

    expect(page).to have_content(I18n.t("helpers.legend.conversion_new_date_history_form.revised_date"))
    expect(page).to have_content(I18n.t("helpers.label.conversion_new_date_history_form.note_body"))

    click_on(I18n.t("conversion_new_date_history_form.cancel"))

    expect(page).to have_content(project.conversion_date.to_formatted_s(:govuk))
  end

  scenario "they can view the conversion date change note on the projects notes view" do
    project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false, assigned_to: user)
    revised_conversion_date = (Date.today + 6.months).at_beginning_of_month
    note = "This is a test note."

    visit project_path(project)

    click_on(I18n.t("conversion_new_date_history_form.new"))

    fill_in("Month", with: revised_conversion_date.month)
    fill_in("Year", with: revised_conversion_date.year)
    fill_in(I18n.t("helpers.label.conversion_new_date_history_form.note_body"), with: note)
    click_button(I18n.t("conversion_new_date_history_form.submit"))

    click_on("continue working on this conversion")
    click_on("Notes")

    expect(page).to have_content(note)
  end

  context "when the project conversion date is provisional" do
    scenario "they cannot change the conversion date" do
      project = create(:conversion_project, assigned_to: user, conversion_date_provisional: true)

      visit project_path(project)

      expect(page).not_to have_link(I18n.t("conversion_new_date_history_form.new"))
    end
  end

  scenario "the proposed or confirmed conversion date is clearly shown" do
    proposed_project = create(:conversion_project, conversion_date_provisional: true, conversion_date: Date.new(2026, 6, 1))

    visit project_date_history_path(proposed_project)

    expect(page).to have_content "The current proposed conversion date is 1 June 2026"

    confirmed_project = create(:conversion_project, conversion_date_provisional: false, conversion_date: Date.new(2026, 6, 1))

    visit project_date_history_path(confirmed_project)

    expect(page).to have_content "The current confirmed conversion date is 1 June 2026"
  end

  scenario "they can view all of the changes to the conversion date" do
    provisional_date = Date.today.at_beginning_of_month
    confirmed_date = provisional_date
    first_revised_date = confirmed_date + 1.month
    second_revised_date = first_revised_date + 2.months
    first_reason = [{type: :legacy_reason, note_text: "This is the first test reason note."}]
    second_reason = [{type: :legacy_reason, note_text: "This is the second test reason note."}]
    third_reason = [{type: :legacy_reason, note_text: "This is the third test reason note."}]

    project = create(:conversion_project, conversion_date: provisional_date, conversion_date_provisional: true, assigned_to: user)

    visit project_date_history_path(project)

    expect(page).to have_content "Conversion date history"
    expect(page).to have_content "No date history"

    SignificantDateCreatorService.new(project: project, revised_date: confirmed_date, reasons: first_reason, user: user).update!

    visit project_date_history_path(project)

    within(".govuk-summary-card:nth-of-type(1)") do
      expect(page).to have_content user.email
      expect(page).to have_content provisional_date.to_fs(:govuk_month)
      expect(page).to have_content confirmed_date.to_fs(:govuk_month)
      expect(page).to have_content "Legacy reason, see note"
      expect(page).to have_content "This is the first test reason note."
    end

    SignificantDateCreatorService.new(project: project, revised_date: first_revised_date, reasons: second_reason, user: user).update!

    visit project_date_history_path(project)

    within(".govuk-summary-card:nth-of-type(1)") do
      expect(page).to have_content user.email
      expect(page).to have_content confirmed_date.to_fs(:govuk_month)
      expect(page).to have_content first_revised_date.to_fs(:govuk_month)
      expect(page).to have_content "Legacy reason, see note"
      expect(page).to have_content "This is the second test reason note."
    end

    SignificantDateCreatorService.new(project: project, revised_date: second_revised_date, reasons: third_reason, user: user).update!

    visit project_date_history_path(project)

    within(".govuk-summary-card:nth-of-type(1)") do
      expect(page).to have_content user.email
      expect(page).to have_content first_revised_date.to_fs(:govuk_month)
      expect(page).to have_content second_revised_date.to_fs(:govuk_month)
      expect(page).to have_content "Legacy reason, see note"
      expect(page).to have_content "This is the third test reason note."
    end
  end
end
