require "rails_helper"

RSpec.feature "Users can manage user accounts" do
  let(:user) { create(:user, :service_support, first_name: "Service", last_name: "Support", email: "service.support@education.gov.uk") }

  before do
    sign_in_with_user(user)
  end

  scenario "by viewing a list of the user accounts" do
    other_user = create(:user, first_name: "Other", last_name: "User", email: "other.user@education.gov.uk")

    visit users_path

    expect(page).to have_content(user.full_name)
    expect(page).to have_content(other_user.full_name)
  end
end
