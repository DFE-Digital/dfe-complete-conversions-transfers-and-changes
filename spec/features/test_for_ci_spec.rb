require "rails_helper"

RSpec.feature "Test that selenium works in CI" do
  let(:user) { create(:user) }

  before do
    sign_in_with_user(user)
  end

  scenario "the test runs", driver: :headless_firefox do
    visit root_path

    expect(page).to have_content("Project list")
  end
end
