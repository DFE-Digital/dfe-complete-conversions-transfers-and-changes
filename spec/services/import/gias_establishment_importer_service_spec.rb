require "rails_helper"

RSpec.describe Import::GiasEstablishmentCsvImporterService do
  describe "#import!" do
    it "takes a csv file and imports the GIAS establishment it contains" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.to change { Gias::Establishment.count }
      expect(Gias::Establishment.count).to eql(1)

      imported_record = Gias::Establishment.last

      expect(imported_record.name).to eql("The Lanes Primary School")
      expect(imported_record.urn).to eql(144731)
    end

    it "it skips row when there is no change for the record" do
      establishment = create(:gias_establishment, urn: 144731)

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect(establishment).not_to receive(:update!)
      expect { service.import! }.not_to change { Gias::Establishment.count }
    end

    it "does not create duplicate records based on the urn, updating instead" do
      establishment = create(:gias_establishment, urn: 144731, name: "School name")

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.not_to change { Gias::Establishment.count }
      expect(establishment.reload.name).to eql("The Lanes Primary School")
    end
  end

  describe "#required_columns_present?" do
    it "returns true when all required column headers are in the file" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect(service.required_columns_present?).to be true
    end

    it "returns false when not all required headers are in the file" do
      path = file_fixture("gias_establishment_data_bad.csv")
      service = described_class.new(path)

      expect(service.required_columns_present?).to be false
    end

    it "returns false when there are no headers i.e. the file is empty" do
      path = file_fixture("gias_establishment_data_empty.csv")
      service = described_class.new(path)

      expect(service.required_columns_present?).to be false
    end
  end

  describe "#csv_row_attributes" do
    it "returns the values that are required by the importer and nothing else" do
      row = CSV::Row.new(
        ["URN", "Other column"],
        ["123456", "not intereseted"]
      )

      service = described_class.new("/path")
      row_attributes = service.csv_row_attributes(row)

      expect(row_attributes["urn"]).to eql "123456"
      expect(row_attributes.keys).not_to include("Other column")
      expect(row_attributes.values).not_to include("not intereseted")
    end

    it "maps the csv headers to the attributes used by the model" do
      row = CSV::Row.new(
        ["URN", "LA (code)"],
        ["123456", "200"]
      )

      service = described_class.new("/path")
      row_attributes = service.csv_row_attributes(row)

      expect(row_attributes.keys).to include("urn")
      expect(row_attributes.keys).to include("local_authority_code")
    end
  end

  describe "#compare_attributes" do
    it "returns false when there is no change" do
      model_attributes = {urn: 123456, name: "A school name"}
      csv_attributes = {urn: "123456", name: "A school name"}

      service = described_class.new("/path")
      result = service.values_updated?(csv_attributes, model_attributes)

      expect(result).to be false
    end

    it "returns true when the values in the csv have changed" do
      model_attributes = {urn: 123456, name: "A school name"}
      csv_attributes = {urn: "123456", name: "A updated school name"}

      service = described_class.new("/path")
      result = service.values_updated?(csv_attributes, model_attributes)

      expect(result).to be true
    end
  end
end
