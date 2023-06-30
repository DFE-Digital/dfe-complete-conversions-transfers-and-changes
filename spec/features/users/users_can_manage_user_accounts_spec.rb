require "rails_helper"

RSpec.feature "Users can manage user accounts" do
  let(:user) { create(:user, :service_support, first_name: "Service", last_name: "Support", email: "service.support@education.gov.uk") }

  before do
    sign_in_with_user(user)
  end

  scenario "by viewing a list of the user accounts" do
    other_user = create(:user, first_name: "Other", last_name: "User", email: "other.user@education.gov.uk")

    visit users_path

    within("tbody") do
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(other_user.full_name)
      expect(page).to have_content("Service Support")
    end
  end

  scenario "new users can be added" do
    visit users_path

    click_on "Add a new user"
    fill_in "First name", with: "First"
    fill_in "Last name", with: "Last"
    fill_in "Email address", with: "first.last@education.gov.uk"
    choose "North East"
    check "User is a team lead or manager"

    click_on "Add user"

    expect(page).to have_content("Success")

    within("tbody") do
      expect(page).to have_content("First Last")
      expect(page).to have_content("first.last@education.gov.uk")
    end
  end

  scenario "invalid users cannot be added" do
    visit users_path

    click_on "Add a new user"
    fill_in "First name", with: "First"
    fill_in "Last name", with: "Last"
    fill_in "Email address", with: "first.last@not-education-domain.gov.uk"
    choose "North East"
    check "User is a team lead or manager"

    click_on "Add user"

    expect(page).to have_content("There is a problem")
  end
end
