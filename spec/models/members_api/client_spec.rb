require "rails_helper"

RSpec.describe MembersApi::Client do
  it "uses the environment variables to build the connection" do
    ClimateControl.modify(
      MEMBERS_API_HOST: "https://members-api.test"
    ) do
      client_connection = described_class.new.connection

      expect(client_connection.scheme).to eql "https"
      expect(client_connection.host).to eql "members-api.test"
    end
  end
end
