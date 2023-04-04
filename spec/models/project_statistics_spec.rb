require "rails_helper"

RSpec.describe ProjectStatistics, type: :model do
  subject { ProjectStatistics.new }
  before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

  describe "all projects" do
    let!(:voluntary_in_progress_project_1) { create(:conversion_project, completed_at: nil) }
    let!(:sponsored_in_progress_project_2) { create(:involuntary_conversion_project, completed_at: nil) }
    let!(:voluntary_completed_project_1) { create(:conversion_project, completed_at: Date.today + 2.years) }
    let!(:sponsored_completed_project_2) { create(:involuntary_conversion_project, completed_at: Date.today + 2.years) }

    describe "#total_number_of_projects" do
      it "returns the total number of all projects" do
        expect(subject.total_number_of_projects).to eql(4)
      end
    end

    describe "#total_number_of_voluntary_projects" do
      it "returns the total number of all voluntary projects" do
        expect(subject.total_number_of_voluntary_projects).to eql(2)
      end
    end

    describe "#total_number_of_sponsored_projects" do
      it "returns the total number of all sponsored projects" do
        expect(subject.total_number_of_sponsored_projects).to eql(2)
      end
    end

    describe "#total_number_of_in_progress_projects" do
      it "returns the total number of all in-progress projects" do
        expect(subject.total_number_of_in_progress_projects).to eql(2)
      end
    end

    describe "#total_number_of_completed_projects" do
      it "returns the total number of all completed projects" do
        expect(subject.total_number_of_completed_projects).to eql(2)
      end
    end
  end
end
