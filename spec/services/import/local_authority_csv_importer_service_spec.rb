require "rails_helper"

RSpec.describe Import::LocalAuthorityCsvImporterService do
  subject { Import::LocalAuthorityCsvImporterService.new }

  let(:csv_path) { "/csv/local_authorities.csv" }
  let(:csv) do
    <<~CSV
      LA , Local authority name,DCS Address 1,DCS Address 2,DCS Address 3,DCS Town,DCS County,DCS Postcode
      202,Camden London Borough Council,5 Pancras Square,0,0,0,London,N1C 4AG
      203,Royal Borough of Greenwich Council,Woolwich Centre,35  Wellington Street,Woolwich,London,,SE18 6HQ
      204,Hackney London Borough Council,1 Reading Lane,,0,0,London,E8 1GQ
      209,Lewisham London Borough,"1st Floor, Laurence House",1 Catford Road,0,0,London,SE6 4RU
    CSV
  end

  before {
    allow(File).to receive(:open).with(csv_path, any_args).and_return(csv)
  }

  describe "#call" do
    it "upserts local authorities from the provided CSV" do
      subject.call(csv_path)

      expect(LocalAuthority.count).to be 4

      expect(LocalAuthority.find_by(code: "202").attributes).to include(
        "name" => "Camden London Borough Council",
        "code" => "202",
        "address_1" => "5 Pancras Square",
        "address_2" => nil,
        "address_3" => nil,
        "address_town" => nil,
        "address_county" => "London",
        "address_postcode" => "N1C 4AG"
      )

      expect(
        LocalAuthority.find_by(code: "203").attributes
      ).to include(
        "name" => "Royal Borough of Greenwich Council",
        "code" => "203",
        "address_1" => "Woolwich Centre",
        "address_2" => "35  Wellington Street",
        "address_3" => "Woolwich",
        "address_town" => "London",
        "address_county" => nil,
        "address_postcode" => "SE18 6HQ"
      )

      expect(
        LocalAuthority.find_by(code: "204").attributes
      ).to include(
        "name" => "Hackney London Borough Council",
        "code" => "204",
        "address_1" => "1 Reading Lane",
        "address_2" => nil,
        "address_3" => nil,
        "address_town" => nil,
        "address_county" => "London",
        "address_postcode" => "E8 1GQ"
      )

      expect(
        LocalAuthority.find_by(code: "209").attributes
      ).to include(
        "name" => "Lewisham London Borough",
        "code" => "209",
        "address_1" => "1st Floor, Laurence House",
        "address_2" => "1 Catford Road",
        "address_3" => nil,
        "address_town" => nil,
        "address_county" => "London",
        "address_postcode" => "SE6 4RU"
      )
    end

    context "when a row is malformed" do
      let(:csv) do
        <<~CSV
          LA , Local authority name,DCS Address 1,DCS Address 2,DCS Address 3,DCS Town,DCS County,DCS Postcode
          202,Camden London Borough Council,5 Pancras Square,0,0,0,London,N1C 4AG
          000,Malformed,Record,,
          203,Royal Borough of Greenwich Council,Woolwich Centre,35  Wellington Street,Woolwich,London,,SE18 6HQ
        CSV
      end

      it "raises an InvalidEntryError" do
        expect { subject.call(csv_path) }.to raise_error(InvalidEntryError)
      end

      it "does not save the malformed row" do
        expect { subject.call(csv_path) }.to raise_error(InvalidEntryError)

        expect(
          LocalAuthority.where(
            code: "000"
          )
        ).not_to exist
      end
    end
  end

  describe "#sanitized_csv" do
    context "when a cell is blank" do
      let(:csv) do
        <<~CSV
          cell_1,cell_2,cell_3
          text1,,text2
        CSV
      end

      it "it inserts a nil value for the blank cell" do
        expect(subject.sanitized_csv(csv_path)).to eql([{cell_1: "text1", cell_2: nil, cell_3: "text2"}])
      end
    end

    context "when a cell a contains 0 values" do
      let(:csv) do
        <<~CSV
          cell_1,cell_2,cell_3
          text1,0,text2
        CSV
      end

      it "it inserts a nil value for the 0 cell" do
        expect(subject.sanitized_csv(csv_path)).to eql([{cell_1: "text1", cell_2: nil, cell_3: "text2"}])
      end
    end
  end
end
