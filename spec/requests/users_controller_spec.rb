require "rails_helper"

RSpec.describe UsersController, type: :request do
  let(:user) { create(:user, :service_support) }

  before { sign_in_with(user) }

  describe "#create" do
    it "sends the new account added email" do
      new_user = build(:user, email: "new.user@education.gov.uk", team: :regional_casework_services)

      expect(UserAccountMailer).to receive(:new_account_added).exactly(1).time

      post users_path(user: new_user.attributes)
    end
  end
end
