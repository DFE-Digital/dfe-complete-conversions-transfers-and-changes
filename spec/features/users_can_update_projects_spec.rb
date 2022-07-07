require "rails_helper"

RSpec.feature "Users can reach the edit project page" do
  scenario "by following a link from the show project page" do
    sign_in_with_user(create(:user))

    single_project = Project.create!(urn: 19283746)

    visit project_path(single_project.id)
    click_on I18n.t("project.show.edit_button.text")
    expect(page).to have_content(I18n.t("project.edit.title"))
    expect(page).to have_content(single_project.urn.to_s)
  end
end

RSpec.feature "Users can update a project" do
  let(:user_email) { "user@education.gov.uk" }

  before(:each) do
    sign_in_with_user(create(:user, email: user_email))
  end

  context "when the project has no delivery officer" do
    scenario "the delivery officer can be set" do
      single_project = Project.create!(urn: 19283746)

      visit edit_project_path(single_project.id)
      select user_email, from: "project-delivery-officer-id-field"
      click_on "Continue"
      expect(page).to have_content(user_email)
    end
  end

  context "when the project already has a delivery officer" do
    scenario "the delivery officer can be changed" do
      user2 = create(:user, email: "user2@education.gov.uk")

      single_project = Project.create!(urn: 19283746, delivery_officer: user2)

      visit edit_project_path(single_project.id)
      select user_email, from: "project-delivery-officer-id-field"
      click_on "Continue"
      expect(page).to have_content(user_email)
    end

    scenario "the delivery officer can be unset" do
      user = User.find_by(email: "user@education.gov.uk")

      single_project = Project.create!(urn: 19283746, delivery_officer: user)

      visit edit_project_path(single_project.id)
      select "", from: "project-delivery-officer-id-field"
      click_on "Continue"
      expect(page).to have_content(I18n.t("project.summary.delivery_officer.unassigned"))
    end
  end
end

RSpec.feature "Users can unset the delivery officer of a project" do
  scenario "when the project already has a delivery officer" do
    sign_in_with_user(create(:user))
    user = User.find_by(email: "user@education.gov.uk")

    single_project = Project.create!(urn: 19283746, delivery_officer: user)

    visit edit_project_path(single_project.id)
    select "", from: "project-delivery-officer-id-field"
    click_on "Continue"
    expect(page).to have_content(I18n.t("project.summary.delivery_officer.unassigned"))
  end
end
