require "rails_helper"

RSpec.describe Export::NewPreConversionGrantsForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:from_date) }
    it { is_expected.to validate_presence_of(:to_date) }

    describe "from and to date order" do
      it "validates from is before to" do
        form = described_class.new(from_date: Date.new(2024, 1, 1), to_date: Date.new(2023, 1, 1))

        expect(form).to be_invalid
        expect(form.errors.messages_for(:from_date)).to include "From date must be before to date"
        expect(form.errors.messages_for(:to_date)).to include "To date must be after from date"
      end
    end
  end

  describe "#export" do
    it "uses the appropriate project scopes" do
      from_date = Date.new(2024, 1, 1)
      to_date = Date.new(2024, 4, 1)
      form = described_class.new(from_date: from_date, to_date: to_date)

      allow(Project).to receive(:not_deleted).and_call_original
      allow(Project).to receive(:conversions).and_call_original
      allow(Project).to receive(:advisory_board_date_in_range).and_call_original

      form.export

      expect(Project).to have_received(:not_deleted)
      expect(Project).to have_received(:conversions)
      expect(Project).to have_received(:advisory_board_date_in_range).with(from_date, to_date)
    end

    it "uses the appropriate csv export service" do
      from_date = Date.new(2024, 1, 1)
      to_date = Date.new(2024, 4, 1)
      form = described_class.new(from_date: from_date, to_date: to_date)
      fake_csv_export_service = double(call: [])

      allow(Export::Conversions::PreConversionGrantsCsvExportService).to receive(:new).and_return(fake_csv_export_service)

      form.export

      expect(Export::Conversions::PreConversionGrantsCsvExportService).to have_received(:new).once
      expect(fake_csv_export_service).to have_received(:call).once
    end

    describe "includes the right projects" do
      before do
        mock_all_academies_api_responses
      end

      let(:from_date) { Date.new(2024, 1, 1) }
      let(:to_date) { Date.new(2024, 4, 1) }

      let!(:active_project) { create(:conversion_project, :active, advisory_board_date: Date.new(2024, 2, 1), urn: 111111) }
      let!(:completed_project) { create(:conversion_project, :completed, advisory_board_date: Date.new(2024, 1, 1), urn: 222222) }
      let!(:dao_revoked_project) { create(:conversion_project, :dao_revoked, advisory_board_date: Date.new(2024, 1, 1), urn: 333333) }
      let!(:deleted_project) { create(:conversion_project, :deleted, advisory_board_date: Date.new(2024, 2, 1), urn: 444444) }
      let!(:inactive_project) { create(:conversion_project, :inactive, advisory_board_date: Date.new(2024, 2, 1), urn: 555555) }

      subject { described_class.new(from_date: from_date, to_date: to_date).export }

      it "includes active projects" do
        expect(subject).to include active_project.urn.to_s
      end

      it "includes completed projects" do
        expect(subject).to include completed_project.urn.to_s
      end

      it "includes DAO revoked projects" do
        expect(subject).to include dao_revoked_project.urn.to_s
      end

      it "does not include deleted projects" do
        expect(subject).not_to include deleted_project.urn.to_s
      end

      it "does not include inactive projects" do
        expect(subject).not_to include inactive_project.urn.to_s
      end
    end
  end
end
