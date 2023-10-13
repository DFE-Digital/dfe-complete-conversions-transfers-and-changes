require "rails_helper"

RSpec.describe ServiceSupport::Upload::Gias::UploadEstablishmentsForm do
  let(:uploaded_file) { fixture_file_upload("gias_establishment_data_good.csv", "text/csv") }
  let(:user) { create(:service_support_user) }
  let(:file_path) { Rails.root.join("spec", "fixtures", "files", "gias_establishments_#{DateTime.now.strftime("%Y-%m-%d-%H:%M:%s")}.csv") }

  before do
    freeze_time
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  it "generates a unique filename" do
    expected_file_path = Rails.root.join("storage", "uploads", "gias", "establishments", "gias_establishments_#{DateTime.now.strftime("%Y-%m-%d-%H%M%S")}.csv")
    form = described_class.new(uploaded_file, user)
    expect(form.file_path).to eq(expected_file_path)
  end

  it "uploads the file with the correct filename on save" do
    allow_any_instance_of(ServiceSupport::Upload::Gias::UploadEstablishmentsForm).to receive(:file_path).and_return(file_path)

    described_class.new(uploaded_file, user).save
    expect(File.exist?(file_path)).to be true
  end

  describe "validations" do
    context "when the file is empty" do
      let(:uploaded_file) { fixture_file_upload("gias_establishment_data_empty.csv", "text/csv") }

      it "is invalid" do
        form = described_class.new(uploaded_file, user)
        expect(form).to_not be_valid
      end

      it "does not save the file" do
        described_class.new(uploaded_file, user)
        expect(File.exist?(file_path)).to be false
      end
    end

    context "when no file is uploaded" do
      let(:uploaded_file) { nil }

      it "is invalid" do
        form = described_class.new(uploaded_file, user)
        expect(form).to_not be_valid
      end
    end

    context "when the file is greater than 150Mb" do
      let(:uploaded_file) { fixture_file_upload("gias_establishment_data_good.csv", "text/csv") }

      before do
        allow(File).to receive(:size).and_return(200000000)
      end

      it "is invalid" do
        form = described_class.new(uploaded_file, user)
        expect(form).to_not be_valid
      end
    end

    context "when the file is not CSV" do
      let(:uploaded_file) { fixture_file_upload("text_file.txt", "text/plain") }

      it "is invalid" do
        form = described_class.new(uploaded_file, user)
        expect(form).to_not be_valid
      end
    end

    context "when the file does not contain the required columns" do
      let(:uploaded_file) { fixture_file_upload("gias_establishment_data_bad.csv", "text/csv") }

      it "is invalid" do
        form = described_class.new(uploaded_file, user)
        expect(form).to_not be_valid
      end
    end
  end

  context "when the form is valid" do
    let(:importer) { double(Import::GiasEstablishmentImportJob, perform_later: true) }

    before do
      allow_any_instance_of(ServiceSupport::Upload::Gias::UploadEstablishmentsForm).to receive(:file_path).and_return(file_path)
      allow(Import::GiasEstablishmentImportJob).to receive(:set).and_return(importer)
    end

    it "calls Import::GiasEstablishmentImportJob" do
      form = described_class.new(uploaded_file, user)
      expect(form).to be_valid
      form.save
      expect(Import::GiasEstablishmentImportJob).to have_received(:set).with(wait_until: Date.tomorrow.in_time_zone.change(hour: 4))
      expect(importer).to have_received(:perform_later).with(file_path.to_s, user)
    end
  end
end
