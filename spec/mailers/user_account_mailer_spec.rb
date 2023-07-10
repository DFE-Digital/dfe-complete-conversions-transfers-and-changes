require "rails_helper"

RSpec.describe UserAccountMailer do
  describe "#new_account_added" do
    it "sends an email with the correct personalisation" do
      user = build(:user, first_name: "First", last_name: "Last", email: "first.last@education.gov.uk")

      expect_any_instance_of(Mail::Notify::Mailer)
        .to receive(:template_mail)
        .with("d55de8f1-ce5a-4498-8229-baac7c0ee45f", {to: user.email, personalisation: {first_name: "First"}})

      UserAccountMailer.new_account_added(user).deliver_now
    end
  end
end
