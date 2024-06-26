require "rails_helper"

RSpec.describe ByMonthProjectFetcherService do
  describe "#conversion_projects_by_date_range" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      it "only includes active projects that are assigned to a user" do
        significant_date = Date.parse("2023-1-1")
        user = create(:user)
        dao_project = create(
          :conversion_project,
          significant_date: significant_date,
          significant_date_provisional: false,
          directive_academy_order: true,
          state: :dao_revoked,
          assigned_to: user
        )
        create(:dao_revocation, project: dao_project)

        _completed_project = create(
          :conversion_project,
          completed_at: Date.today,
          state: :completed,
          significant_date: significant_date,
          significant_date_provisional: false,
          assigned_to: user
        )

        _unassigned_project = create(
          :conversion_project,
          significant_date: significant_date,
          significant_date_provisional: false,
          assigned_to: nil
        )

        result = described_class.new.conversion_projects_by_date_range("2023-1-1", "2023-1-1")

        expect(result).to be_empty
      end

      it "returns all conversion projects with a confirmed date in the desired range, and orders by significant date" do
        january = Date.parse("2023-1-1")
        february = Date.parse("2023-2-1")
        march = Date.parse("2023-3-1")

        project_1 = create(:conversion_project, significant_date_provisional: false, significant_date: january)
        project_2 = create(:conversion_project, significant_date_provisional: false, significant_date: february)
        project_3 = create(:conversion_project, significant_date_provisional: false, significant_date: march)

        unconfirmed_project = create(:conversion_project, significant_date_provisional: true, significant_date: january)
        completed_project = create(:conversion_project, :completed, significant_date: january)

        create(:date_history, project: project_1, previous_date: january, revised_date: january)
        create(:date_history, project: project_2, previous_date: february, revised_date: march)
        create(:date_history, project: project_3, previous_date: march, revised_date: march)

        result = described_class.new.conversion_projects_by_date_range("2023-1-1", "2023-3-1")
        expect(result).to eq([project_1, project_2, project_3])
        expect(result).not_to include(unconfirmed_project)
        expect(result).not_to include(completed_project)
      end
    end
  end

  describe "#transfer_projects_by_date_range" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      it "only includes active projects that are assigned to a user" do
        significant_date = Date.parse("2023-1-1")
        user = create(:user)

        _completed_project = create(
          :transfer_project,
          completed_at: Date.today,
          state: :completed,
          significant_date: significant_date,
          significant_date_provisional: false,
          assigned_to: user
        )

        _unassigned_project = create(
          :transfer_project,
          significant_date: significant_date,
          significant_date_provisional: false,
          assigned_to: nil
        )

        result = described_class.new.transfer_projects_by_date_range("2023-1-1", "2023-1-1")

        expect(result).to be_empty
      end

      it "returns all transfer projects with a confirmed date in the desired range, and orders by significant date" do
        january = Date.parse("2023-1-1")
        february = Date.parse("2023-2-1")
        march = Date.parse("2023-3-1")

        project_1 = create(:transfer_project, significant_date_provisional: false, significant_date: january)
        project_2 = create(:transfer_project, significant_date_provisional: false, significant_date: february)
        project_3 = create(:transfer_project, significant_date_provisional: false, significant_date: march)

        create(:date_history, project: project_1, previous_date: january, revised_date: january)
        create(:date_history, project: project_2, previous_date: february, revised_date: march)
        create(:date_history, project: project_3, previous_date: march, revised_date: march)

        unconfirmed_project = create(:transfer_project, significant_date_provisional: true, significant_date: january)
        completed_project = create(:transfer_project, :completed, significant_date: january)

        result = described_class.new.transfer_projects_by_date_range("2023-1-1", "2023-3-1")
        expect(result).to eq([project_1, project_2, project_3])
        expect(result).not_to include(unconfirmed_project)
        expect(result).not_to include(completed_project)
      end
    end
  end
end
