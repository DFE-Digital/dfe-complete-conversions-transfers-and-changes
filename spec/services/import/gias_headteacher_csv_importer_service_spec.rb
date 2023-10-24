require "rails_helper"

RSpec.describe Import::GiasHeadteacherCsvImporterService do
  describe "#import!" do
    it "takes a csv file and imports the head teacher contact details it contains" do
      create(:gias_establishment, urn: 144731)
      create(:gias_establishment, urn: 144865)
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.to change { Contact::Establishment.count }
      expect(Contact::Establishment.count).to eql(2)

      imported_records = Contact::Establishment.order(:establishment_urn)

      expect(imported_records.first.name).to eql("Jane Brown")
      expect(imported_records.first.establishment_urn).to eql(144731)

      expect(imported_records.last.name).to eql("Bob Smith")
      expect(imported_records.last.establishment_urn).to eql(144865)
    end

    it "does not create duplicate contact records based on the urn, updating instead" do
      create(:gias_establishment, urn: 144731)
      contact = create(:establishment_contact, establishment_urn: 144731, name: "Bob Smith")
      create(:establishment_contact, establishment_urn: 144865)

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.not_to change { Contact::Establishment.count }

      contact.reload

      expect(contact.name).to eql("Jane Brown")
      expect(contact.email).to eql("jane.brown@school.sch.uk")
    end

    it "returns a hash of results from the import" do
      create(:gias_establishment, urn: 144731)
      create(:gias_establishment, urn: 144865)
      create(:gias_establishment, urn: 121583)

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      result = service.import!

      expect(result[:file]).to eql(path)
      expect(result[:total_csv_rows]).to eql(3)
      expect(result[:time_taken]).not_to be_nil
    end

    describe "the results hash" do
      it "includes the number of skipped rows" do
        create(:gias_establishment, urn: 144731)
        create(:gias_establishment, urn: 144865)
        create(:gias_establishment, urn: 121583)
        path = file_fixture("gias_establishment_data_good.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:skipped_csv_rows]).to eql(1)
      end

      it "includes the number of rows that have contact data" do
        create(:gias_establishment, urn: 144731)
        create(:gias_establishment, urn: 144865)
        create(:gias_establishment, urn: 121583)
        path = file_fixture("gias_establishment_data_good.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:total_csv_rows_with_a_contact]).to eql(2)
      end

      it "includes the number of new contacts" do
        create(:gias_establishment, urn: 144731)
        create(:gias_establishment, urn: 144865)
        create(:gias_establishment, urn: 121583)
        create(:establishment_contact, establishment_urn: 144731, name: "Jane Brown")
        path = file_fixture("gias_establishment_data_good.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:new_contacts]).to eql(1)
      end

      it "includes the number of contacts that changed" do
        create(:gias_establishment, urn: 144731)
        create(:gias_establishment, urn: 144865)
        create(:gias_establishment, urn: 121583)
        create(:establishment_contact, establishment_urn: 144731, name: "Another Headteacher")
        path = file_fixture("gias_establishment_data_good.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:contacts_changed]).to eql(1)
      end

      it "includes the number of contacts that did not change" do
        create(:gias_establishment, urn: 144731)
        create(:gias_establishment, urn: 144865)
        create(:gias_establishment, urn: 121583)
        create(:establishment_contact,
          establishment_urn: 144731,
          organisation_name: "The Lanes Primary School",
          title: "Headteacher",
          name: "Jane Brown",
          email: "jane.brown@school.sch.uk",
          category: "school_or_academy")

        path = file_fixture("gias_establishment_data_good.csv")
        service = described_class.new(path)

        result = service.import!

        expect(result[:contacts_not_changed]).to eql(1)
      end

      it "includes the changes" do
        create(:gias_establishment, urn: 144731)
        create(:gias_establishment, urn: 144865)
        create(:gias_establishment, urn: 121583)
        create(:establishment_contact, establishment_urn: 144865, name: "Kevin Wilkins")

        path = file_fixture("gias_establishment_data_good.csv")
        service = described_class.new(path)

        result = service.import!
        changes = result.dig(:changes, "144865")

        expect(changes.dig("name", :new_value)).to eql("Bob Smith")
        expect(changes.dig("name", :previous_value)).to eql("Kevin Wilkins")
      end
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
      expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] Source file not/a/path.csv could not be found.")
    end

    it "does nothing and logs when the file does not have the correct headers" do
      path = file_fixture("gias_establishment_data_bad.csv")
      service = described_class.new(path)
      logger = double(info: true)
      allow(Rails).to receive(:logger).and_return(logger)

      result = service.import!

      expect(result[:total_csv_rows]).to be_zero
      expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] Source file spec/fixtures/files/gias_establishment_data_bad.csv does not contain the required headers.")
    end
  end

  describe "#import_row" do
    describe "Headteacher title" do
      it "is set to 'headteacher' if the value is empty" do
        create(:gias_establishment, urn: 144731)
        row = valid_csv_row

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        new_contact = Contact::Establishment.last
        expect(new_contact.title).to eql("Headteacher")
      end
    end

    describe "row errors" do
      it "skips the row and logs the error when the establishment cannot be found" do
        row = CSV::Row.new(["URN"], ["123456"])
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] Could not find an establishment with the URN: 123456 - skipping row.")
      end

      it "skips the row and logs the error when the required values are not in the row" do
        create(:gias_establishment, urn: 144731)
        row = empty_csv_row
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] The required fields are not present in the row for the establishment with URN: 144731 - skipping row.")
      end

      it "skips the row and logs the error when the contact cannot be created or found" do
        create(:gias_establishment, urn: 144731)
        row = valid_csv_row
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)
        allow(Contact::Establishment).to receive(:find_or_create_by).and_return(nil)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be false
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] Could not find or create the contact for establishment with URN: 144731 - skipping row.")
      end

      it "logs when the contact is found or created" do
        create(:gias_establishment, urn: 144731)
        row = valid_csv_row
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] Contact found or created for establishment with URN: 144731.")
      end

      it "logs when the contact is updated" do
        create(:gias_establishment, urn: 144731)
        contact = create(:establishment_contact, establishment_urn: 144731, name: "Jane Brown")
        row = valid_csv_row
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(contact.reload.email).to eql("j.wilkins@school.ac.uk")
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] Contact updated for establishment with URN: 144731.")
      end

      it "logs when the contact cannot be updated" do
        create(:gias_establishment, urn: 144731)
        contact = create(:establishment_contact, establishment_urn: 144731, email: "jane.brown@school.ac.uk")
        row = valid_csv_row
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)
        allow(contact).to receive(:update).and_return(nil)
        allow(Contact::Establishment).to receive(:find_or_create_by).and_return(contact)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(contact.reload.email).not_to eql("j.wilkins@school.ac.uk")
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] Could not update contact for establishment with URN: 144731.")
      end

      it "logs when there are no changes to the contact" do
        create(:gias_establishment, urn: 144731, name: "A School")
        create(:establishment_contact, establishment_urn: 144731, organisation_name: "A School", title: "Headteacher", name: "Jane Wilkins", email: "j.wilkins@school.ac.uk", category: "school_or_academy")
        row = valid_csv_row
        logger = double(info: true)
        allow(Rails).to receive(:logger).and_return(logger)

        service = described_class.new("/fake/path")

        expect(service.import_row(row)).to be true
        expect(logger).to have_received(:info).with("[IMPORT][GIAS][HEADTEACHER] No changes to contact for establishment with URN: 144731.")
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

  describe "#contact_csv_row_attributes" do
    it "returns the values that are required by the importer and nothing else" do
      row = CSV::Row.new(
        ["URN", "Other column"],
        ["123456", "not interested"]
      )

      service = described_class.new("/path")
      row_attributes = service.contact_csv_row_attributes(row)

      expect(row_attributes["establishment_urn"]).to eql "123456"
      expect(row_attributes.keys).not_to include("Other column")
      expect(row_attributes.values).not_to include("not interested")
    end

    it "maps the csv headers to the attributes used by the model" do
      row = CSV::Row.new(
        ["URN", "HeadFirstName", "HeadLastName", "HeadEmail"],
        ["123456", "Bob", "Smith", "bob.smith@school.sch.uk"]
      )

      service = described_class.new("/path")
      row_attributes = service.contact_csv_row_attributes(row)

      expect(row_attributes.keys).to include("establishment_urn")
      expect(row_attributes.keys).to include("name")
      expect(row_attributes.values).to include("Bob Smith")
      expect(row_attributes.values).to include("school_or_academy")
    end
  end

  describe "#changed_attributes" do
    it "returns empty when there is no change" do
      model_attributes = {urn: 123456, name: "Head Teacher"}
      csv_attributes = {urn: "123456", name: "Head Teacher"}

      service = described_class.new("/path")
      result = service.changed_attributes(csv_attributes, model_attributes)

      expect(result).to eql({})
    end

    it "returns true when the values in the csv have changed" do
      model_attributes = {urn: 123456, name: "Head Teacher"}
      csv_attributes = {urn: "123456", name: "Updated Teacher"}

      service = described_class.new("/path")
      result = service.changed_attributes(csv_attributes, model_attributes)

      expect(result).to eql({name: {previous_value: "Head Teacher", new_value: "Updated Teacher"}})
    end
  end
end

def valid_csv_row
  CSV::Row.new(
    ["URN",
      "EstablishmentName",
      "HeadPreferredJobTitle",
      "HeadFirstName",
      "HeadLastName",
      "HeadEmail"],
    ["144731",
      "A School",
      "",
      "Jane",
      "Wilkins",
      "j.wilkins@school.ac.uk"]
  )
end

def empty_csv_row
  CSV::Row.new(
    ["URN",
      "EstablishmentName",
      "HeadPreferredJobTitle",
      "HeadFirstName",
      "HeadLastName",
      "HeadEmail"],
    ["144731",
      "",
      "",
      "",
      "",
      "",
      ""]
  )
end
