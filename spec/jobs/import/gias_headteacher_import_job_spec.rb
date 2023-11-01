require "rails_helper"

RSpec.describe Import::GiasHeadteacherImportJob, type: :job do
  describe "#perform" do
    let(:user) { create(:user, :service_support) }
    let(:importer) { double(Import::GiasHeadteacherCsvImporterService, import!: true) }
    subject { described_class }

    before do
      allow(Import::GiasHeadteacherCsvImporterService).to receive(:new).and_return(importer)
      allow(File).to receive(:delete).and_return(true)
    end

    let(:file_path) { "gias_establishment_data_good.csv" }

    it "queues the job" do
      subject.perform_later(file_path, user)
      expect(subject).to have_been_enqueued.exactly(:once)
    end

    it "calls the importer service" do
      subject.perform_now(file_path, user)
      expect(importer).to have_received(:import!)
    end

    it "deletes the file afterwards" do
      subject.perform_now(file_path, user)
      expect(File).to have_received(:delete).with(file_path)
    end
  end
end
