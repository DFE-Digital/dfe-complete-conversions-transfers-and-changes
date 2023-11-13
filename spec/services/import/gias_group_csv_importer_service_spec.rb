require "rails_helper"

RSpec.describe Import::GiasGroupCsvImporterService do
  describe "#import!" do
    it "takes a csv file and imports the GIAS groups it contains" do
      path = file_fixture("gias_groups_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.to change { Gias::Group.count }
      expect(Gias::Group.count).to eql(3)

      imported_records = Gias::Group.order(:unique_group_identifier)

      expect(imported_records.first.unique_group_identifier).to eql(1000)
      expect(imported_records.first.original_name).to eql("Federated Governing Body of Egerton Park Arts College and Two Trees Sports College")

      expect(imported_records.last.unique_group_identifier).to eql(1002)
      expect(imported_records.last.original_name).to eql("The Federation of John Rankin Infant and Nursery School and John Rankin Junior School")
    end

    it "it skips row when there is no change for the record" do
      path = file_fixture("gias_groups_data_good.csv")
      service = described_class.new(path)
      service.import!

      group_record = Gias::Group.last
      allow(group_record).to receive(:update!)

      expect { service.import! }.not_to change { Gias::Group.count }
      expect(group_record).not_to have_received(:update!)
    end

    it "does not create duplicate group records based on the unique_group_identifier, updating instead" do
      group = create(:gias_group, unique_group_identifier: 1000, original_name: "Trust name")
      create(:gias_group, unique_group_identifier: 1001)
      create(:gias_group, unique_group_identifier: 1002)

      path = file_fixture("gias_groups_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.not_to change { Gias::Group.count }
      expect(group.reload.original_name).to eql("Federated Governing Body of Egerton Park Arts College and Two Trees Sports College")
    end

    it "returns a hash of results from the import" do
      create(:gias_group, unique_group_identifier: 1000, original_name: "Trust name")

      path = file_fixture("gias_groups_data_good.csv")
      service = described_class.new(path)

      result = service.import!

      expect(result[:total_csv_rows]).to eql(3)
      expect(result[:new_groups]).to eql(2)
      expect(result[:groups_changed]).to eql(1)
      expect(result[:time_taken]).to be_truthy
    end

    describe "file errors" do
      it "does nothing and logs when the file is not found" do
        path = "not/a/path.csv"
        service = described_class.new(path)
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        result = service.import!

        expect(result[:total_csv_rows]).to be_zero
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][GROUP] Source file not/a/path.csv could not be found.")
      end

      it "does nothing and logs when the file does not have the correct headers" do
        path = file_fixture("gias_establishment_data_bad.csv")
        service = described_class.new(path)
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        result = service.import!

        expect(result[:total_csv_rows]).to be_zero
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][GROUP] Source file spec/fixtures/files/gias_establishment_data_bad.csv does not contain the required headers.")
      end
    end

    describe "row errors" do
      it "skips the row and logs the error when the group cannot be found or a new one created" do
        row = CSV::Row.new(["Group UID"], ["1234"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)
        allow(Gias::Group).to receive(:find_or_create_by).with(unique_group_identifier: "1234").and_return(nil)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][GROUP] Could not find or create the group with unique_group_identifier: 1234 - skipping row.")
      end

      it "skips the row and logs the error when the required values are not in the row" do
        invalid_row = CSV::Row.new(
          ["UKPRN"],
          [""]
        )
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(invalid_row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][GROUP] The required fields are not present in row 1 - skipping row.")
      end

      it "logs when the group is found" do
        create(:gias_group, unique_group_identifier: 1000)
        row = CSV::Row.new(["Group UID"], ["1000"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][GROUP] Group found or created with unique_group_identifier: 1000.")
      end

      it "logs when the group is created" do
        row = CSV::Row.new(["Group UID"], ["1000"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][GROUP] Group found or created with unique_group_identifier: 1000.")
      end

      it "logs when updating the group fails" do
        group = create(:gias_group, unique_group_identifier: 1000)
        row = CSV::Row.new(["Group UID"], ["1000"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)
        allow(group).to receive(:update).and_return(false)
        allow(Gias::Group).to receive(:find_or_create_by).and_return(group)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][GROUP] Could not update group, unique_group_identifier: 1000.")
      end
    end
  end

  describe "#required_column_headers_present?" do
    it "returns true when all required column headers are in the file" do
      path = file_fixture("gias_groups_data_good.csv")
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
        ["Group UID", "Other column"],
        ["1234", "not interested"]
      )

      service = described_class.new("/path")
      row_attributes = service.csv_row_attributes(row)

      expect(row_attributes["unique_group_identifier"]).to eql "1234"
      expect(row_attributes.keys).not_to include("Other column")
      expect(row_attributes.values).not_to include("not interested")
    end

    it "maps the csv headers to the attributes used by the model" do
      row = CSV::Row.new(
        ["Group UID", "Group Name"],
        ["1234", "Trust Company Inc"]
      )

      service = described_class.new("/path")
      row_attributes = service.csv_row_attributes(row)

      expect(row_attributes.keys).to include("unique_group_identifier")
      expect(row_attributes.keys).to include("original_name")
    end
  end

  describe "#changed_attributes" do
    it "returns empty when there is no change" do
      model_attributes = {unique_group_identifier: 1234, original_name: "A trust name"}
      csv_attributes = {unique_group_identifier: "1234", original_name: "A trust name"}

      service = described_class.new("/path")
      result = service.changed_attributes(csv_attributes, model_attributes)

      expect(result).to eql({})
    end

    it "returns true when the values in the csv have changed" do
      model_attributes = {unique_group_identifier: 1234, original_name: "A trust name"}
      csv_attributes = {unique_group_identifier: "1234", original_name: "An updated trust name"}

      service = described_class.new("/path")
      result = service.changed_attributes(csv_attributes, model_attributes)

      expect(result).to eql({original_name: {previous_value: "A trust name", new_value: "An updated trust name"}})
    end
  end
end
