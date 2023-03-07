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
    let!(:existing_user) { create(:user, email: existing_user_email, first_name: "Jane") }

    subject(:call_user_importer) { user_importer.call(csv_path) }

    it "upserts users from the provided CSV" do
      call_user_importer

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

    context "when an existing user has been updated" do
      let(:users_csv) do
        <<~CSV
          email,first_name,last_name,team_leader,regional_delivery_officer
          john.doe@education.gov.uk,John,Doe,1,0
          jane.doe@education.gov.uk,Jane,Doe,1,0
        CSV
      end

      it "updates the existing user in place" do
        call_user_importer

        expect(User.find_by(email: existing_user_email).regional_delivery_officer).to be false
        expect(User.find_by(email: existing_user_email).team_leader).to be true
      end
    end

    context "when an error occurs" do
      let(:users_csv) do
        <<~CSV
          email,first_name,last_name,team_leader,regional_delivery_officer
          #{existing_user_email},Josephine,Doe,0,1
          ,Malformed,Record,,
        CSV
      end

      it "rolls back the transaction" do
        expect { call_user_importer }.to raise_error(InvalidEntryError)

        expect(User.count).to be 1

        expect(
          User.where(
            email: existing_user_email,
            first_name: "Jane",
            last_name: "Doe",
            team_leader: false,
            regional_delivery_officer: false
          )
        ).to exist
      end
    end

    context "when an email address is invalid" do
      let(:users_csv) do
        <<~CSV
          email,first_name,last_name,team_leader,regional_delivery_officer
          john.doe.education.gov.uk,John,Doe,1,0
          jane.doe@education.gov.uk,Jane,Doe,1,0
        CSV
      end

      it "returns an error message and does not create a user with that email address" do
        expect { call_user_importer }.to raise_error(InvalidEntryError)
        expect(User.find_by(email: "john.doe.education.gov.uk")).to eql(nil)
      end
    end
  end
end
