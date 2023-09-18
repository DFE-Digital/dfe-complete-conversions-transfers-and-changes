require "rails_helper"

RSpec.describe Import::GiasEstablishmentCsvImporterService do
  describe "#import!" do
    it "takes a csv file and imports the GIAS establishment it contains" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.to change { Gias::Establishment.count }
      expect(Gias::Establishment.count).to eql(2)

      imported_records = Gias::Establishment.order(:urn)

      expect(imported_records.first.name).to eql("The Lanes Primary School")
      expect(imported_records.first.urn).to eql(144731)

      expect(imported_records.last.name).to eql("Lightcliffe C of E Primary School")
      expect(imported_records.last.urn).to eql(144865)
    end

    it "it skips row when there is no change for the record" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)
      service.import!

      record = Gias::Establishment.last
      allow(record).to receive(:update!)

      expect { service.import! }.not_to change { Gias::Establishment.count }
      expect(record).not_to have_received(:update!)
    end

    it "does not create duplicate records based on the urn, updating instead" do
      establishment = create(:gias_establishment, urn: 144731, name: "School name")
      create(:gias_establishment, urn: 144865)

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.not_to change { Gias::Establishment.count }
      expect(establishment.reload.name).to eql("The Lanes Primary School")
    end

    it "returns a hash of statistics for the import" do
      create(:gias_establishment, urn: 144865, name: "School name")

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      result = service.import!

      expect(result[:total]).to eql(2)
      expect(result[:new]).to eql(1)
      expect(result[:changed]).to eql(2)
      expect(result[:time]).to be_truthy
    end

    it "returns a hash that includes the changes" do
      create(:gias_establishment, urn: 144865, name: "School name")

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      result = service.import!
      changes = result.dig(:changes, 144865)

      expect(changes.dig("name", :new_value)).to eql("Lightcliffe C of E Primary School")
      expect(changes.dig("name", :previous_value)).to eql("School name")
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
        ["123456", "not interested"]
      )

      service = described_class.new("/path")
      row_attributes = service.csv_row_attributes(row)

      expect(row_attributes["urn"]).to eql "123456"
      expect(row_attributes.keys).not_to include("Other column")
      expect(row_attributes.values).not_to include("not interested")
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

  describe "#changed_attributes" do
    it "returns empty when there is no change" do
      model_attributes = {urn: 123456, name: "A school name"}
      csv_attributes = {urn: "123456", name: "A school name"}

      service = described_class.new("/path")
      result = service.changed_attributes(csv_attributes, model_attributes)

      expect(result).to eql({})
    end

    it "returns true when the values in the csv have changed" do
      model_attributes = {urn: 123456, name: "A school name"}
      csv_attributes = {urn: "123456", name: "A updated school name"}

      service = described_class.new("/path")
      result = service.changed_attributes(csv_attributes, model_attributes)

      expect(result).to eql({name: {previous_value: "A school name", new_value: "A updated school name"}})
    end
  end
end
