require "rails_helper"

RSpec.describe UserImporter do
  let(:csv_path) { "/csv/users.csv" }
  let(:user_importer) { UserImporter.new }
  let(:users_csv) do
    <<~CSV
      email,first_name,last_name,team_leader,regional_delivery_officer
      john.doe@education.gov.uk,John,Doe,1,0
      jane.doe@education.gov.uk,Jane,Doe,0,1
    CSV
  end

  before { allow(File).to receive(:open).and_return(users_csv) }

  describe "#call" do
    let(:existing_user_email) { "jane.doe@education.gov.uk" }
    let!(:existing_user) { create(:user, email: existing_user_email) }

    subject! { user_importer.call(csv_path) }

    it "upserts users from the provided CSV" do
      expect(User.count).to be 2

      expect(
        User.where(
          email: "john.doe@education.gov.uk",
          first_name: "John",
          last_name: "Doe",
          team_leader: true,
          regional_delivery_officer: false
        )
      ).to exist

      expect(
        User.where(
          email: existing_user_email,
          first_name: "Jane",
          last_name: "Doe",
          team_leader: false,
          regional_delivery_officer: true
        )
      ).to exist
    end
  end
end
