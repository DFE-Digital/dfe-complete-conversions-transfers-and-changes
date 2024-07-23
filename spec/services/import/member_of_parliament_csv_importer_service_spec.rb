require "rails_helper"

RSpec.describe Import::MemberOfParliamentCsvImporterService do
  subject { Import::MemberOfParliamentCsvImporterService.new }

  let(:csv_path) { "/csv/members_of_parliament.csv" }
  let(:csv) do
    <<~CSV
      "value.latestHouseMembership.membershipFrom","value.nameFullTitle","value.email"
      "Tottenham","Rt Hon David Lammy MP","david.lammy.mp@parliament.uk"
      "Hackney North and Stoke Newington","Rt Hon Diane Abbott MP","diane.abbott.office@parliament.uk"
      "East Ham","Rt Hon Sir Stephen Timms MP","timmss@parliament.uk"
    CSV
  end

  before { allow(File).to receive(:open).with(csv_path, any_args).and_return(csv) }

  describe "#call" do
    it "upserts members of parliament contacts from the provided CSV" do
      subject.call(csv_path)

      expect(Contact::Parliament.count).to be 3

      expect(Contact::Parliament.find_by(parliamentary_constituency: "east ham").attributes).to include(
        "name" => "Rt Hon Sir Stephen Timms MP",
        "title" => "Member of Parliament for East Ham",
        "category" => "member_of_parliament",
        "organisation_name" => "HM Government",
        "email" => "timmss@parliament.uk"
      )
    end

    context "when a row is missing an email" do
      let(:csv) do
        <<~CSV
          "value.latestHouseMembership.membershipFrom","value.nameFullTitle","value.email"
          "Tottenham","Rt Hon David Lammy MP",""
        CSV
      end

      it "does not save the that row" do
        subject.call(csv_path)

        expect(Contact::Parliament.where(parliamentary_constituency: "tottenham")).not_to exist
      end
    end

    context "when a row is missing a name but has an email" do
      let(:csv) do
        <<~CSV
          "value.latestHouseMembership.membershipFrom","value.nameFullTitle","value.email"
          "Tottenham","","david.lammy.mp@parliament.uk"
        CSV
      end

      it "raises an error" do
        expect { subject.call(csv_path) }.to raise_error(InvalidEntryError)
      end
    end

    context "when a row is has a malformed email" do
      let(:csv) do
        <<~CSV
          "value.latestHouseMembership.membershipFrom","value.nameFullTitle","value.email"
          "Tottenham","David Lammy MP","david.lammy.mpparliament.uk"
        CSV
      end

      it "raises an error" do
        expect { subject.call(csv_path) }.to raise_error(InvalidEntryError)
      end
    end
  end
end
