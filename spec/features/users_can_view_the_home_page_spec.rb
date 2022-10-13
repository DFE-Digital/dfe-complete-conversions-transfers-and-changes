require "rails_helper"

RSpec.feature "Users can view the home page" do
  let(:user) { create(:user, :caseworker) }
  before do
    sign_in_with_user(user)
  end

  scenario "they see the phase banner and a link to the feedback form" do
    visit root_path

    within(".govuk-phase-banner") do
      expect(page).to have_content(I18n.t("phase_banner.phase"))
      expect(page.html).to include(I18n.t("phase_banner.phase_notice.html"))
    end
  end
end
