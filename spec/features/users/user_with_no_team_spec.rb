require "rails_helper"

RSpec.feature "Users with no team set" do
  scenario "are asked to provide one" do
    user = User.new(
      first_name: "First",
      last_name: "Last",
      email: "first.last@education.gov.uk",
      team: nil
    )
    user.save(validate: false)

    sign_in_with_user(user)

    expect(page).to have_content("Choose the team most relevant to the work you do.")

    choose "North East"
    click_on "Save team"

    expect(page).to have_content("Success")
    expect(user.reload.team).to eq "north_east"
  end

  scenario "they cannot submit no team" do
    user = User.new(
      first_name: "First",
      last_name: "Last",
      email: "first.last@education.gov.uk",
      team: nil
    )
    user.save(validate: false)

    sign_in_with_user(user)

    click_on "Save team"

    expect(page).to have_content("There is a problem")
    expect(page).to have_content("Choose a team")
  end
end
