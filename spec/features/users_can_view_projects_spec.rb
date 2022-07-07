require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  scenario "on the home page" do
    sign_in_with_user(create(:user))

    single_project = Project.create!(urn: 19283746)

    visit root_path
    expect(page).to have_content(single_project.urn.to_s)
  end
end

RSpec.feature "Users can view a single project" do
  scenario "by following a link from the home page" do
    sign_in_with_user(create(:user))

    single_project = Project.create!(urn: 19283746)

    visit root_path
    click_on single_project.urn.to_s
    expect(page).to have_content(single_project.urn.to_s)
  end

  context "when a project does not have an assigned delivery officer" do
    scenario "the project list shows an unassigned delivery officer" do
      sign_in_with_user(create(:user))
      Project.create!(urn: 19283746)

      visit projects_path
      expect(page).to have_content(I18n.t("project.summary.delivery_officer.unassigned"))
    end

    scenario "the project page shows an unassigned delivery officer" do
      sign_in_with_user(create(:user))
      single_project = Project.create!(urn: 19283746)

      visit project_path(single_project)
      expect(page).to have_content(I18n.t("project.summary.delivery_officer.unassigned"))
    end
  end

  context "when a project has an assigned delivery officer" do
    let(:user_email_address) { "user@education.gov.uk" }

    scenario "the project list shows an assigned delivery officer" do
      sign_in_with_user(create(:user, email: user_email_address))
      user = User.find_by(email: user_email_address)
      Project.create!(urn: 19283746, delivery_officer: user)

      visit projects_path
      expect(page).to have_content(user_email_address)
    end

    scenario "the project page shows an assigned delivery officer" do
      sign_in_with_user(create(:user, email: user_email_address))
      user = User.find_by(email: user_email_address)
      single_project = Project.create!(urn: 19283746, delivery_officer: user)

      visit project_path(single_project.id)
      expect(page).to have_content(user_email_address)
    end
  end
end
