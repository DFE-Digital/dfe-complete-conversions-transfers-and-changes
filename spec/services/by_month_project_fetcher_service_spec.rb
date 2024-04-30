require "rails_helper"

RSpec.describe ByMonthProjectFetcherService do
  describe "#conversion_projects_by_date_range" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
      end

      it "returns all conversion projects with a confirmed date in the desired range, and orders by significant date" do
        january = Date.parse("2023-1-1")
        february = Date.parse("2023-2-1")
        march = Date.parse("2023-3-1")

        project_1 = create(:conversion_project, significant_date_provisional: false, significant_date: january)
        project_2 = create(:conversion_project, significant_date_provisional: false, significant_date: february)
        project_3 = create(:conversion_project, significant_date_provisional: false, significant_date: march)

        create(:date_history, project: project_1, previous_date: january, revised_date: january)
        create(:date_history, project: project_2, previous_date: february, revised_date: march)
        create(:date_history, project: project_3, previous_date: march, revised_date: march)

        projects_fetcher = described_class.new
        expect(projects_fetcher.conversion_projects_by_date_range("2023-1-1", "2023-3-1")).to eq([project_1, project_2, project_3])
      end
    end
  end

  describe "#transfer_projects_by_date_range" do
    context "with pre fetching disabled for this test" do
      before do
        mock_all_academies_api_responses
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

        projects_fetcher = described_class.new
        expect(projects_fetcher.transfer_projects_by_date_range("2023-1-1", "2023-3-1")).to eq([project_1, project_2, project_3])
      end
    end
  end

  describe "#conversion_projects_by_date" do
    context "with prefetching disabled for this test" do
      it "returns conversion projects and orders by all conditions met & establishment name" do
        project_one = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "Y school"))
        project_two = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "B school"))
        project_three = double(Conversion::Project, all_conditions_met?: false, establishment: double("Establishment", name: "A school"))
        project_four = double(Conversion::Project, all_conditions_met?: true, establishment: double("Establishment", name: "Z school"))

        allow(Project).to receive(:filtered_by_significant_date).and_return([project_one, project_two, project_three, project_four])

        projects = described_class.new(pre_fetch_academies_api: false).conversion_projects_by_date(1, 2025)

        expect(projects).to eq [project_four, project_three, project_two, project_one]
      end
    end
  end

  describe "#transfer_projects_by_date" do
    context "with prefetching disabled for this test" do
      it "returns transfer projects and orders by all conditions met & establishment name" do
        project_one = double(Transfer::Project, all_conditions_met?: false, establishment: double("Establishment", name: "Y school"))
        project_two = double(Transfer::Project, all_conditions_met?: false, establishment: double("Establishment", name: "B school"))
        project_three = double(Transfer::Project, all_conditions_met?: false, establishment: double("Establishment", name: "A school"))
        project_four = double(Transfer::Project, all_conditions_met?: true, establishment: double("Establishment", name: "Z school"))

        allow(Project).to receive(:filtered_by_significant_date).and_return([project_one, project_two, project_three, project_four])

        projects = described_class.new(pre_fetch_academies_api: false).transfer_projects_by_date(1, 2025)

        expect(projects).to eq [project_four, project_three, project_two, project_one]
      end
    end
  end
end
