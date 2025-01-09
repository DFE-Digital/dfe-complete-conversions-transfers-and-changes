require "rails_helper"

RSpec.describe Import::UserCsvImporterService do
  let(:csv_path) { "/csv/users.csv" }
  let(:user_importer) { Import::UserCsvImporterService.new }
  let(:users_csv) do
    <<~CSV
      email,first_name,last_name,team,manage_team,add_new_project,assign_to_project
      john.doe@education.gov.uk,John,Doe,regional_casework_services,1,0,0
      jane.doe@education.gov.uk,Jane,Doe,london,0,1,0
    CSV
  end

  before {
    Project.destroy_all
    User.destroy_all
    allow(File).to receive(:open).and_return(users_csv)
  }

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
          manage_team: true,
          add_new_project: false,
          team: "regional_casework_services"
        )
      ).to exist

      expect(
        User.where(
          email: existing_user_email,
          first_name: "Jane",
          last_name: "Doe",
          manage_team: false,
          add_new_project: true,
          team: "london"
        )
      ).to exist
    end

    context "when an existing user has been updated" do
      let(:users_csv) do
        <<~CSV
          email,first_name,last_name,team,manage_team,add_new_project,assign_to_project
          john.doe@education.gov.uk,John,Doe,regional_casework_services,1,0,0
          jane.doe@education.gov.uk,Jane,Doe,regional_casework_services,1,0,0
        CSV
      end

      it "updates the existing user in place" do
        call_user_importer

        expect(User.find_by(email: existing_user_email).add_new_project).to be false
        expect(User.find_by(email: existing_user_email).manage_team).to be true
      end
    end

    context "when an error occurs" do
      let(:users_csv) do
        <<~CSV
          email,first_name,last_name,manage_team,add_new_project
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
            manage_team: false,
            add_new_project: false
          )
        ).to exist
      end
    end

    context "when an email address is invalid" do
      let(:users_csv) do
        <<~CSV
          email,first_name,last_name,manage_team,add_new_project
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
