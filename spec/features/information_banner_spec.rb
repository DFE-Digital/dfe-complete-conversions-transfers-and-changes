require "rails_helper"

RSpec.feature "Users can see an information banner" do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    sign_in_with_user(user)
  end

  context "with the environment variable present and set to true" do
    it "shows the banner on all pages" do
      ClimateControl.modify SHOW_INFORMATION_BANNER: "true" do
        visit in_progress_your_projects_path

        expect(page).to have_selector("#information-banner")

        visit all_in_progress_projects_path

        expect(page).to have_selector("#information-banner")
      end
    end

    it "shows the title and body" do
      ClimateControl.modify SHOW_INFORMATION_BANNER: "true" do
        visit in_progress_your_projects_path

        within("#information-banner") do
          expect(page).to have_content(I18n.t("information_banner.title"))
          expect(page.html).to include(I18n.t("information_banner.body.html"))
        end
      end
    end
  end

  context "with the environment variable present and set to false" do
    it "does not show the banner" do
      ClimateControl.modify SHOW_INFORMATION_BANNER: "false" do
        visit in_progress_your_projects_path

        expect(page).not_to have_selector("#information-banner")
      end
    end
  end

  context "without the environment variable set" do
    it "does not show the banner" do
      visit in_progress_your_projects_path

      expect(page).not_to have_selector("#information-banner")
    end
  end
end
