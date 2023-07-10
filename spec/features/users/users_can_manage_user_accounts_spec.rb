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
      expect(page).to have_content("No")
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

  scenario "existing users can be edited" do
    existing_user = create(:user, :regional_delivery_officer, team: "london")

    visit edit_user_path(existing_user)

    choose "North East"
    click_on "Save user"

    expect(existing_user.reload.team).to eql "north_east"
  end

  scenario "exisiting users cannot be made invalid" do
    existing_user = create(:user, :regional_delivery_officer, team: "london")

    visit edit_user_path(existing_user)

    fill_in "First name", with: ""
    click_on "Save user"

    expect(page).to have_content("There is a problem")
  end

  scenario "existing users can be disabled" do
    existing_user = create(:user)

    visit edit_user_path(existing_user)
    check "Disabled"

    click_on "Save user"

    expect(existing_user.reload.disabled).to be true

    click_on "Disabled users"

    within("tbody") do
      expect(page).to have_content(existing_user.email)
    end
  end

  scenario "disabled users can be enabled" do
    existing_user = create(:disabled_user)

    visit edit_user_path(existing_user)
    uncheck "Disabled"

    click_on "Save user"

    expect(existing_user.reload.disabled).to be false

    click_on "Enabled users"

    within("tbody") do
      expect(page).to have_content(existing_user.email)
    end
  end

  context "then the users team is nil becuase it is a legacy account" do
    scenario "no team is shown" do
      other_user = User.new(
        first_name: "First",
        last_name: "Last",
        email: "first.last@education.gov.uk",
        team: nil
      )
      other_user.save(validate: false)

      sign_in_with_user(user)

      visit users_path

      within("tbody") do
        expect(page).to have_content("No team")
      end
    end
  end
end
