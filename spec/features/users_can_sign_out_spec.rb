require "rails_helper"

RSpec.feature "Users can sign out of the applicaiton" do
  scenario "by visiting the `/sign-out` url" do
    visit sign_out_path

    expect(page).to have_content(I18n.t("sign_out.message.success"))
    expect(page).to have_button(I18n.t("sign_in.button"))
    expect(page.current_path).to eq "/sign-in"
  end
end
