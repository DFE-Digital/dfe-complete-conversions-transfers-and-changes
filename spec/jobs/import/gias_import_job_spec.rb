require "rails_helper"

RSpec.describe Import::GiasImportJob, type: :job do
  describe "#perform" do
    let(:user) { create(:user, :service_support) }
    let(:establishment_importer) { double(Import::Gias::EstablishmentCsvImporterService, import!: {}) }
    subject { described_class }

    before do
      allow(Import::Gias::EstablishmentCsvImporterService).to receive(:new).and_return(establishment_importer)
      allow(File).to receive(:delete).and_return(true)
    end

    let(:file_path) { "gias_establishment_data_good.csv" }

    it "queues the job" do
      subject.perform_later(file_path, user)
      expect(subject).to have_been_enqueued.exactly(:once)
    end

    it "calls both the importer services" do
      subject.perform_now(file_path, user)
      expect(establishment_importer).to have_received(:import!)
    end

    it "queues an email to the user with the import report" do
      establishment_mock_mailer = double(GiasEstablishmentImportMailer, deliver_later: true)
      expect(GiasEstablishmentImportMailer).to receive(:import_notification).and_return(establishment_mock_mailer)

      subject.perform_now(file_path, user)

      expect(establishment_mock_mailer).to have_received(:deliver_later).exactly(1).time
    end

    it "deletes the file afterwards" do
      subject.perform_now(file_path, user)
      expect(File).to have_received(:delete).with(file_path)
    end
  end

  describe "#emailable_result" do
    it "removes the changes from the result as the hash can be too large to queue with Sidekiq" do
      test_result = {
        included: 0,
        changes: {}
      }

      expect(subject.emailable_result(test_result).has_key?(:changes)).to be false
    end
  end
end
