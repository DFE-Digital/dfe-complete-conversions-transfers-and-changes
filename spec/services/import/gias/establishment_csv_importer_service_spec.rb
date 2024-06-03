require "rails_helper"

RSpec.describe Import::Gias::EstablishmentCsvImporterService do
  describe "#import!" do
    it "takes a csv file and imports the GIAS establishment it contains" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.to change { Gias::Establishment.count }
      expect(Gias::Establishment.count).to eql(3)

      imported_records = Gias::Establishment.order(:urn)

      expect(imported_records.first.name).to eql("Roecliffe Church of England Primary School")
      expect(imported_records.first.urn).to eql(121583)
      expect(imported_records.first.open_date).to eql(Date.new(2020, 1, 1))
      expect(imported_records.first.status).to eql("Open")

      expect(imported_records.last.name).to eql("Lightcliffe C of E Primary School")
      expect(imported_records.last.urn).to eql(144865)
      expect(imported_records.last.open_date).to eql(Date.new(2021, 1, 1))
      expect(imported_records.last.status).to eql("Closed")
    end

    it "it skips row when there is no change for the record" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)
      service.import!

      establishment_record = Gias::Establishment.last
      allow(establishment_record).to receive(:update!)

      expect { service.import! }.not_to change { Gias::Establishment.count }
      expect(establishment_record).not_to have_received(:update!)
    end

    it "does not create duplicate establishment records based on the urn, updating instead" do
      establishment = create(:gias_establishment, urn: 144731, name: "School name")
      create(:gias_establishment, urn: 144865)
      create(:gias_establishment, urn: 121583)

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.not_to change { Gias::Establishment.count }
      expect(establishment.reload.name).to eql("The Lanes Primary School")
    end

    it "returns a hash of results from the import" do
      create(:gias_establishment, urn: 144865, name: "School name")

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      result = service.import!

      expect(result[:total_csv_rows]).to eql(3)
      expect(result[:new]).to eql(2)
      expect(result[:changed]).to eql(1)
      expect(result[:time_taken]).to be_truthy
    end

    describe "the results hash" do
      it "includes the number of skipped rows" do
        path = file_fixture("gias_establishment_data_good_with_bad_row.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:skipped_csv_rows]).to eql(1)
      end

      it "includes the number of new establishments created" do
        path = file_fixture("gias_establishment_data_good_with_bad_row.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:new]).to eql(2)
      end

      it "includes the number of changed establishments" do
        create(:gias_establishment, urn: 144865)
        path = file_fixture("gias_establishment_data_good_with_bad_row.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:changed]).to eql(1)
      end

      it "includes the number of establishments that did not change" do
        path = file_fixture("gias_establishment_data_good_with_bad_row.csv")
        service = described_class.new(path)

        service.import!

        result = service.import!

        expect(result[:no_changes]).to eql(2)
      end

      it "includes the changes" do
        path = file_fixture("gias_establishment_data_good_with_bad_row.csv")
        service = described_class.new(path)

        service.import!

        Gias::Establishment.find_by_urn(144731).update!(name: "This should change")

        result = service.import!

        changes = result.dig(:changes, "144731")

        expect(changes.dig("name", :new_value)).to eql("The Lanes Primary School")
        expect(changes.dig("name", :previous_value)).to eql("This should change")
      end
    end

    describe "file errors" do
      it "does nothing and logs when the file is not found" do
        path = "not/a/path.csv"
        service = described_class.new(path)
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        result = service.import!

        expect(result[:total_csv_rows]).to be_zero
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][ESTABLISHMENT] Source file not/a/path.csv could not be found.")
      end

      it "does nothing and logs when the file does not have the correct headers" do
        path = file_fixture("gias_establishment_data_bad.csv")
        service = described_class.new(path)
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        result = service.import!

        expect(result[:total_csv_rows]).to be_zero
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][ESTABLISHMENT] Source file spec/fixtures/files/gias_establishment_data_bad.csv does not contain the required headers.")
      end
    end

    describe "row errors" do
      it "skips the row and logs the error when the establishment cannot be found or a new one created" do
        row = CSV::Row.new(["URN"], ["123456"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)
        allow(Gias::Establishment).to receive(:find_or_create_by).with(urn: "123456").and_return(nil)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][ESTABLISHMENT] Could not find or create an establishment with the URN: 123456 - skipping row.")
      end

      it "skips the row and logs the error when the required values are not in the row" do
        invalid_row = CSV::Row.new(
          ["URN"],
          [""]
        )
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(invalid_row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][ESTABLISHMENT] The required values are not present in row 1 - skipping row.")
      end

      it "logs when the establishment is found" do
        create(:gias_establishment, urn: 123456)
        row = CSV::Row.new(["URN"], ["123456"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][ESTABLISHMENT] Establishment found or created with URN: 123456.")
      end

      it "logs when the establishment is created" do
        row = CSV::Row.new(["URN"], ["123456"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][ESTABLISHMENT] Establishment found or created with URN: 123456.")
      end

      it "logs when updating the establishment fails" do
        establishment = create(:gias_establishment, urn: 123456)
        row = CSV::Row.new(["URN"], ["123456"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)
        allow(establishment).to receive(:update).and_return(false)
        allow(Gias::Establishment).to receive(:find_or_create_by).and_return(establishment)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][ESTABLISHMENT] Could not update establishment with URN: 123456.")
      end
    end
  end

  describe "#required_column_headers_present?" do
    it "returns true when all required column headers are in the file" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect(service.required_column_headers_present?).to be true
    end

    it "returns false when not all required headers are in the file" do
      path = file_fixture("gias_establishment_data_bad.csv")
      service = described_class.new(path)

      expect(service.required_column_headers_present?).to be false
    end

    it "returns false when there are no headers i.e. the file is empty" do
      path = file_fixture("gias_establishment_data_empty.csv")
      service = described_class.new(path)

      expect(service.required_column_headers_present?).to be false
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
