require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  scenario "on the home page" do
    sign_in_with_user("user@education.gov.uk")

    single_project = Project.create!(urn: 19283746)

    visit root_path
    expect(page).to have_content(single_project.urn.to_s)
  end
end
