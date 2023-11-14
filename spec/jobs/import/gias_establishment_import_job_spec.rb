require "rails_helper"

RSpec.describe Import::GiasEstablishmentImportJob, type: :job do
  describe "#perform" do
    let(:user) { create(:user, :service_support) }
    let(:file_path) { "gias_establishment_data_good.csv" }
    let(:importer) { double(Import::Gias::EstablishmentCsvImporterService, import!: {}) }
    subject { described_class }

    before do
      allow(Import::Gias::EstablishmentCsvImporterService).to receive(:new).and_return(importer)
    end

    it "queues the job" do
      subject.perform_later(file_path, user)
      expect(subject).to have_been_enqueued.exactly(:once)
    end

    it "calls the importer service" do
      subject.perform_now(file_path, user)
      expect(importer).to have_received(:import!)
    end

    it "queues an email to the user with the import report" do
      mock_mailer = double(GiasEstablishmentImportMailer, deliver_later: true)
      expect(GiasEstablishmentImportMailer).to receive(:import_notification).and_return(mock_mailer)

      subject.perform_now(file_path, user)

      expect(mock_mailer).to have_received(:deliver_later).exactly(1).time
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
