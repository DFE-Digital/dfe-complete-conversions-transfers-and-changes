require "rails_helper"

RSpec.describe Import::DirectorOfChildServicesCsvImporterService do
  subject { Import::DirectorOfChildServicesCsvImporterService.new }

  let(:csv_path) { "/csv/dcs.csv" }
  let(:csv) do
    <<~CSV
      LA,Name,Title,Email,Phone
      200,John Doe,Executive Director Supporting People,john.doe@camden.gov.uk,0
      201,Sarah White,Director of Children's Services,sarah.white@royalgreenwich.gov.uk,0
      202,Claire Doe,Director of Children's Services,claire.doe@hackney.gov.uk,020 8000 0000
    CSV
  end

  before { allow(File).to receive(:open).with(csv_path, any_args).and_return(csv) }

  describe "#call" do
    context "when all the local authorities exist" do
      before do
        create(:local_authority, code: 200)
        create(:local_authority, code: 201)
        create(:local_authority, code: 202)
      end

      it "upserts directors of child services from the provided CSV" do
        subject.call(csv_path)

        expect(Contact::DirectorOfChildServices.count).to be 3
      end
    end

    context "when a local authority does not exist" do
      it "does not import the directors of child services" do
        expect { subject.call(csv_path) }.to raise_error(MissingLocalAuthorityError)
        expect(Contact::DirectorOfChildServices.count).to eq 0
      end
    end

    context "when a row is malformed" do
      let(:csv) do
        <<~CSV
          LA,Name,Title,Email,Phone
          200,John Doe,,john.doe@camden.gov.uk,0
        CSV
      end

      before { create(:local_authority, code: 200) }

      it "raises an InvalidEntryError" do
        expect { subject.call(csv_path) }.to raise_error(InvalidEntryError)
      end
    end
  end
end
