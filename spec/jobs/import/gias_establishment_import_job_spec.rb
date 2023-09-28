require "rails_helper"

RSpec.describe Import::GiasEstablishmentImportJob, type: :job do
  describe "#perform" do
    let(:user) { create(:user, :service_support) }
    let(:importer) { double(Import::GiasEstablishmentCsvImporterService, import!: true) }
    subject { described_class }

    before do
      allow(Import::GiasEstablishmentCsvImporterService).to receive(:new).and_return(importer)
    end

    context "when the import succeeds" do
      let(:file_path) { "gias_establishment_data_good.csv" }

      it "queues the job" do
        subject.perform_later(file_path, user)
        expect(Import::GiasEstablishmentImportJob).to have_been_enqueued.exactly(:once)
      end

      it "calls the importer service" do
        subject.perform_now(file_path, user)
        expect(importer).to have_received(:import!)
      end

      it "sends an email to the user with the import report" do
        mock_mailer = double(GiasEstablishmentImportMailer, deliver_later: true)
        expect(GiasEstablishmentImportMailer).to receive(:import_notification).and_return(mock_mailer)

        subject.perform_now(file_path, user)

        expect(mock_mailer).to have_received(:deliver_later).exactly(1).time
      end
    end
  end
end
