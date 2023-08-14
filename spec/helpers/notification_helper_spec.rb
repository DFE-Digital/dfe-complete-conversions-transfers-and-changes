require "rails_helper"

RSpec.describe NotificationHelper, type: :helper do
  describe "#notification_banner_html" do
    context "when the banner message does NOT contain html" do
      it "outputs the message in an h3 tag" do
        expect(helper.notification_banner_html("This is a single line message")).to eq '<h3 class="govuk-notification-banner__heading">This is a single line message</h3>'
      end
    end

    context "when the banner message contains html" do
      it "outputs the message as-is (with its html)" do
        message = '<h3 class="govuk-notification-banner__heading">This is a multi line message</h3><p class="govuk-body">With a second line</p>'
        expect(helper.notification_banner_html(message)).to eq '<h3 class="govuk-notification-banner__heading">This is a multi line message</h3><p class="govuk-body">With a second line</p>'
      end
    end
  end
end
