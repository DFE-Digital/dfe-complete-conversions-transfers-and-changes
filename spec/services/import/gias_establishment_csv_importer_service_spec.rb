require "rails_helper"

RSpec.describe Import::GiasEstablishmentCsvImporterService do
  describe "#import!" do
    it "takes a csv file and imports the GIAS establishment it contains" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.to change { Gias::Establishment.count }
      expect(Gias::Establishment.count).to eql(3)

      imported_records = Gias::Establishment.order(:urn)

      expect(imported_records.first.name).to eql("Roecliffe Church of England Primary School")
      expect(imported_records.first.urn).to eql(121583)

      expect(imported_records.last.name).to eql("Lightcliffe C of E Primary School")
      expect(imported_records.last.urn).to eql(144865)
    end

    it "takes a csv file and imports the head teacher contact details it contains" do
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

    it "it skips row when there is no change for the record" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)
      service.import!

      establishment_record = Gias::Establishment.last
      contact_record = Contact::Establishment.last
      allow(establishment_record).to receive(:update!)
      allow(contact_record).to receive(:update!)

      expect { service.import! }.not_to change { Gias::Establishment.count }
      expect { service.import! }.not_to change { Contact::Establishment.count }
      expect(establishment_record).not_to have_received(:update!)
      expect(contact_record).not_to have_received(:update!)
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

    it "does not create duplicate contact records based on the urn, updating instead" do
      contact = create(:establishment_contact, establishment_urn: 144731, name: "Jane Brown")
      create(:establishment_contact, establishment_urn: 144865)

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      expect { service.import! }.not_to change { Contact::Establishment.count }
      expect(contact.reload.name).to eql("Jane Brown")
    end

    it "returns a hash of statistics for the import" do
      create(:gias_establishment, urn: 144865, name: "School name")
      create(:establishment_contact, establishment_urn: 144865, name: "Bob Smith")

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      result = service.import!

      expect(result[:total_csv_rows]).to eql(3)
      expect(result[:new_establishment_records]).to eql(2)
      expect(result[:new_contact_records]).to eql(1)
      expect(result[:changed_establishment_records]).to eql(1)
      expect(result[:changed_contact_records]).to eql(2)
      expect(result[:time]).to be_truthy
    end

    it "returns a hash that includes the changes" do
      create(:gias_establishment, urn: 144865, name: "School name")

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      result = service.import!
      changes = result.dig(:changes, :establishment, "144865")

      expect(changes.dig("name", :new_value)).to eql("Lightcliffe C of E Primary School")
      expect(changes.dig("name", :previous_value)).to eql("School name")
    end

    it "returns a hash that includes an error when the file is not found" do
      path = "not/a/path.csv"
      service = described_class.new(path)

      result = service.import!

      expect(result.dig(:errors, :file)).to eq("The source file at not/a/path.csv could not be found.")
    end

    it "returns a hash that includes an error when the file does not have the correct headers" do
      path = file_fixture("gias_establishment_data_bad.csv")
      service = described_class.new(path)

      result = service.import!

      expect(result.dig(:errors, :headers)).to eq("The source file at spec/fixtures/files/gias_establishment_data_bad.csv does not contain all the required headers.")
    end

    it "returns a hash that includes an error if any row cannot be found or created" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      allow(Gias::Establishment).to receive(:find_or_create_by).with(urn: "144731").and_return(nil)
      allow(Gias::Establishment).to receive(:find_or_create_by).with(urn: "144865").and_call_original
      allow(Gias::Establishment).to receive(:find_or_create_by).with(urn: "121583").and_call_original

      result = service.import!

      expect(result.dig(:errors, :establishment, "144731")).to eq("Could not find or create a record for urn: 144731")
    end

    it "returns a hash that includes an error if any establishment row data cannot be updated" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      allow_any_instance_of(Gias::Establishment).to receive(:update).and_return(false)

      result = service.import!

      expect(result.dig(:errors, :establishment, "144731")).to eq("Could not update establishment record for urn: 144731")
    end

    it "returns a hash that includes an error if any contact row data cannot be updated" do
      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      allow_any_instance_of(Contact::Establishment).to receive(:update).and_return(false)

      result = service.import!

      expect(result.dig(:errors, :contact, "144731")).to eq("Could not update contact record for establishment_urn: 144731")
    end

    it "does not update an establishment contact if the establishment could not be updated" do
      contact = create(:establishment_contact, establishment_urn: 144731, name: "Jane Brown")

      path = file_fixture("gias_establishment_data_good.csv")
      service = described_class.new(path)

      allow_any_instance_of(Gias::Establishment).to receive(:update).and_return(false)
      allow(contact).to receive(:update!)

      service.import!

      expect(contact).not_to have_received(:update!)
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

  describe "#establishment_csv_row_attributes" do
    it "returns the values that are required by the importer and nothing else" do
      row = CSV::Row.new(
        ["URN", "Other column"],
        ["123456", "not interested"]
      )

      service = described_class.new("/path")
      row_attributes = service.establishment_csv_row_attributes(row)

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
      row_attributes = service.establishment_csv_row_attributes(row)

      expect(row_attributes.keys).to include("urn")
      expect(row_attributes.keys).to include("local_authority_code")
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
