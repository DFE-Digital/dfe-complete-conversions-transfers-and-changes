require "rails_helper"

RSpec.feature "Users can manage user accounts" do
  let(:user) { create(:user, :service_support, first_name: "Service", last_name: "Support", email: "service.support@education.gov.uk") }

  before do
    Project.destroy_all
    User.destroy_all
    sign_in_with_user(user)
  end

  scenario "by viewing a list of the user accounts" do
    other_user = create(:user, first_name: "Other", last_name: "User", email: "other.user@education.gov.uk")

    visit service_support_users_path

    within("tbody") do
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(other_user.full_name)
      expect(page).to have_content("Service Support")
      expect(page).to have_content("No")
    end
  end

  scenario "new users can be added" do
    visit service_support_users_path

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
    visit service_support_users_path

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

    visit edit_service_support_user_path(existing_user)

    choose "North East"
    click_on "Save user"

    expect(existing_user.reload.team).to eql "north_east"
  end

  scenario "exisiting users cannot be made invalid" do
    existing_user = create(:user, :regional_delivery_officer, team: "london")

    visit edit_service_support_user_path(existing_user)

    fill_in "First name", with: ""
    click_on "Save user"

    expect(page).to have_content("There is a problem")
  end

  scenario "existing users can be deactivated" do
    existing_user = create(:user)

    visit edit_service_support_user_path(existing_user)
    uncheck "Active"

    click_on "Save user"

    expect(existing_user.reload.active).to be false

    click_on "Inactive users"

    within("tbody") do
      expect(page).to have_content(existing_user.email)
    end
  end

  scenario "inactive users can be activated" do
    existing_user = create(:inactive_user)

    visit edit_service_support_user_path(existing_user)
    check "Active"

    click_on "Save user"

    expect(existing_user.reload.active).to be true

    click_on "Active users"

    within("tbody") do
      expect(page).to have_content(existing_user.email)
    end
  end

  context "then the users team is nil because it is a legacy account" do
    scenario "no team is shown" do
      other_user = User.new(
        first_name: "First",
        last_name: "Last",
        email: "first.last@education.gov.uk",
        team: nil
      )
      other_user.save(validate: false)

      sign_in_with_user(user)

      visit service_support_users_path

      within("tbody") do
        expect(page).to have_content("No team")
      end
    end
  end

  scenario "the user's last session datetime is shown" do
    date = DateTime.new(2023, 0o1, 0o1, 10, 30, 0o0, 0)
    _other_user = create(:user, :caseworker, latest_session: date)

    sign_in_with_user(user)

    visit service_support_users_path

    within("thead") do
      expect(page).to have_content("Last seen")
    end

    within("tbody") do
      expect(page).to have_content(date.to_formatted_s(:govuk_date_time))
    end
  end
end
