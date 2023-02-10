require "rails_helper"

RSpec.describe NotificationBanner, type: :component do
  context "when there is a notice flash" do
    it "displays the correct notification banner" do
      flash = ActionDispatch::Flash::FlashHash.new
      flash.notice = "This is a notice"

      render_inline(described_class.new(flashes: flash))

      expect(page).to have_selector(".govuk-notification-banner--success")
      expect(page).to have_text("Success")
    end
  end

  context "when there is an alert flash" do
    it "displays the correct notification banner" do
      flash = ActionDispatch::Flash::FlashHash.new
      flash.alert = "This is an alert"

      render_inline(described_class.new(flashes: flash))

      expect(page).not_to have_selector(".govuk-notification-banner--success")
      expect(page).to have_text("Important")
    end
  end

  context "when there is no flash" do
    it "does nothing" do
      render_inline(described_class.new(flashes: nil))

      expect(page).not_to have_selector(".govuk-notification-banner")
    end
  end
end
