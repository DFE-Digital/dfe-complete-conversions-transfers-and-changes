require "rails_helper"

RSpec.feature "Regional delivery officers can create new projects" do
  before { sign_in_with_user(user) }

  context "when the user is a regional delivery officer" do
    let(:user) { create(:user, :regional_delivery_officer) }

    it "shows a button that adds a new conversion" do
      visit root_path

      expect(page)
        .to have_link I18n.t("conversion_project.voluntary.new.title"), href: conversions_new_path
    end
  end
end
