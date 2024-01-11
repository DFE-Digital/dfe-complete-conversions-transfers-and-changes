require "rails_helper"

RSpec.describe Import::GrantCertificateDateImporterService do
  let(:csv_path) { "/csv/grant_certificate_dates.csv" }
  let(:date_importer) { Import::GrantCertificateDateImporterService.new }
  let(:date_csv) do
    <<~CSV
      URN,Date
      149962,09/12/2023
      150075,17/10/2023
    CSV
  end

  before { allow(File).to receive(:open).with(csv_path, any_args).and_return(date_csv) }

  before do
    mock_all_academies_api_responses
  end

  describe "#call" do
    subject(:call_date_importer) { date_importer.call(csv_path) }

    context "when dates are all valid and URNs are all present" do
      let(:tasks_data_1) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil) }
      let(:tasks_data_2) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil) }
      let!(:project_1) { create(:conversion_project, academy_urn: 149962, tasks_data: tasks_data_1) }
      let!(:project_2) { create(:conversion_project, academy_urn: 150075, tasks_data: tasks_data_2) }

      it "updates all the project tasks_data" do
        call_date_importer

        expect(project_1.tasks_data.reload.receive_grant_payment_certificate_date_received).to eq(Date.new(2023, 12, 9))
        expect(project_2.tasks_data.reload.receive_grant_payment_certificate_date_received).to eq(Date.new(2023, 10, 17))
      end
    end

    context "when a URN is not valid" do
      let(:tasks_data_1) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil) }
      let!(:project_1) { create(:conversion_project, academy_urn: 149962, tasks_data: tasks_data_1) }

      it "updates all other rows" do
        call_date_importer

        expect(project_1.tasks_data.reload.receive_grant_payment_certificate_date_received).to eq(Date.new(2023, 12, 9))
      end
    end

    context "when a date is not valid" do
      let(:tasks_data_1) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil) }
      let(:tasks_data_2) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil) }
      let!(:project_1) { create(:conversion_project, academy_urn: 149962, tasks_data: tasks_data_1) }
      let!(:project_2) { create(:conversion_project, academy_urn: 150075, tasks_data: tasks_data_2) }
      let(:date_csv) do
        <<~CSV
          URN,Date
          149962,09/12/2023
          150075,17/18/2023
        CSV
      end

      it "updates all other rows" do
        call_date_importer

        expect(project_1.tasks_data.reload.receive_grant_payment_certificate_date_received).to eq(Date.new(2023, 12, 9))
        expect(project_2.tasks_data.reload.receive_grant_payment_certificate_date_received).to be_nil
      end
    end

    context "when a date is zero" do
      let(:tasks_data_1) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil) }
      let(:tasks_data_2) { create(:conversion_tasks_data, receive_grant_payment_certificate_date_received: nil) }
      let!(:project_1) { create(:conversion_project, academy_urn: 149962, tasks_data: tasks_data_1) }
      let!(:project_2) { create(:conversion_project, academy_urn: 150075, tasks_data: tasks_data_2) }
      let(:date_csv) do
        <<~CSV
          URN,Date
          149962,09/12/2023
          150075,0
        CSV
      end

      it "updates all other rows" do
        call_date_importer

        expect(project_1.tasks_data.reload.receive_grant_payment_certificate_date_received).to eq(Date.new(2023, 12, 9))
        expect(project_2.tasks_data.reload.receive_grant_payment_certificate_date_received).to be_nil
      end
    end
  end
end
