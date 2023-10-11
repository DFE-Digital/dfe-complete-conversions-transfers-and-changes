require "rails_helper"

RSpec.describe ServiceSupport::UsersController, type: :request do
  let(:user) { create(:user, :service_support) }

  before { sign_in_with(user) }

  describe "#create" do
    it "sends the new account added email" do
      new_user = build(:user, email: "new.user@education.gov.uk", team: :regional_casework_services)
      mock_mailer = double(UserAccountMailer, deliver_later: true)

      expect(UserAccountMailer).to receive(:new_account_added).and_return(mock_mailer)
      expect(mock_mailer).to receive(:deliver_later).exactly(1).time

      post service_support_users_path(user: new_user.attributes)
    end
  end
end
