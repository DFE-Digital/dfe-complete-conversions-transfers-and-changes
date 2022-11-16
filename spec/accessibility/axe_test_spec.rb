require "rails_helper"
require "axe-rspec"

RSpec.feature "Run axe accessibility tool", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user) }

  before do
    sign_in_with_user(user)
  end

  scenario "test the root page" do
    visit root_path

    expect(page).to be_axe_clean
  end
end
