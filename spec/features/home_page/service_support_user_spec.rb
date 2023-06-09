require "rails_helper"

RSpec.feature "The home page for a service support user" do
  before do
    user = create(:user, :service_support)
    sign_in_with_user(user)
  end

  scenario "redirects to the service support view" do
    visit root_path

    expect(page.current_path).to eql without_academy_urn_service_support_projects_path
  end
end
