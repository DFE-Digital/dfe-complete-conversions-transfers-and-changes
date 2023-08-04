require "rails_helper"

RSpec.describe Statistics::ProjectStatistics, type: :model do
  subject { Statistics::ProjectStatistics.new }
  before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

  describe "all projects" do
    before do
      create_list(:conversion_project, 2, assigned_to: nil)
      create(:conversion_project)
      create(:conversion_project, completed_at: Date.today)
    end

    describe "#total_number_of_projects" do
      it "returns the total number of all projects" do
        expect(subject.total_number_of_projects).to eql(4)
      end
    end

    describe "#total_number_of_in_progress_projects" do
      it "returns the total number of all in-progress projects" do
        expect(subject.total_number_of_in_progress_projects).to eql(1)
      end
    end

    describe "#total_number_of_unassigned_projects" do
      it "returns the total number of all unassigned projects" do
        expect(subject.total_number_of_unassigned_projects).to eql(2)
      end
    end

    describe "#total_number_of_completed_projects" do
      it "returns the total number of all completed projects" do
        expect(subject.total_number_of_completed_projects).to eql(1)
      end
    end
  end

  describe "Regional casework services projects" do
    before do
      create(:conversion_project, team: :regional_casework_services, completed_at: nil)
      create(:conversion_project, team: :regional_casework_services, completed_at: Date.today + 2.years)
      create(:conversion_project, team: :regional_casework_services, assigned_to: nil)
      create(:conversion_project, team: :north_west, assigned_to: nil)
    end

    describe "#total_projects_with_regional_casework_services" do
      it "returns the total number of all projects within regional casework services" do
        expect(subject.total_projects_with_regional_casework_services).to eql(3)
      end
    end

    describe "#in_progress_projects_with_regional_casework_services" do
      it "returns the total number of in-progress projects within regional casework services" do
        expect(subject.in_progress_projects_with_regional_casework_services).to eql(1)
      end
    end

    describe "#completed_projects_with_regional_casework_services" do
      it "returns the total number of completed projects within regional casework services" do
        expect(subject.completed_projects_with_regional_casework_services).to eql(1)
      end
    end

    describe "#unassigned_projects_with_regional_casework_services" do
      it "returns the total number of unassigned projects within regional casework services" do
        expect(subject.unassigned_projects_with_regional_casework_services).to eql(1)
      end
    end
  end

  describe "Regional projects that are not with regional casework services" do
    before do
      create(:conversion_project, team: "london", completed_at: nil)
      create(:conversion_project, team: "london", completed_at: Date.today + 2.years)
      create(:conversion_project, team: "london", completed_at: nil, directive_academy_order: true)
      create(:conversion_project, team: "london", completed_at: Date.today + 2.years, directive_academy_order: true)
      create(:conversion_project, team: "london", assigned_to: nil)
    end

    describe "#total_projects_not_with_regional_casework_services" do
      it "returns the total number of projects not with regional casework services" do
        expect(subject.total_projects_not_with_regional_casework_services).to eql(5)
      end
    end

    describe "#voluntary_projects_not_with_regional_casework_services" do
      it "returns the total number of voluntary projects not with regional casework services" do
        expect(subject.voluntary_projects_not_with_regional_casework_services).to eql(3)
      end
    end

    describe "#sponsored_projects_not_with_regional_casework_services" do
      it "returns the total number of sponsored projects not with regional casework services" do
        expect(subject.sponsored_projects_not_with_regional_casework_services).to eql(2)
      end
    end

    describe "#in_progress_projects_not_with_regional_casework_services" do
      it "returns the total number of in-progress projects not with regional casework services" do
        expect(subject.in_progress_projects_not_with_regional_casework_services).to eql(2)
      end
    end

    describe "#completed_projects_not_with_regional_casework_services" do
      it "returns the total number of completed projects not with regional casework services" do
        expect(subject.completed_projects_not_with_regional_casework_services).to eql(2)
      end
    end

    describe "#unassigned_projects_not_with_regional_casework_services" do
      it "returns the total number of unassigned  projects not within regional casework services" do
        expect(subject.unassigned_projects_not_with_regional_casework_services).to eql(1)
      end
    end
  end

  describe "projects per region" do
    it "returns the statistics for the region" do
      create(:conversion_project, region: :london, completed_at: nil)
      create(:conversion_project, region: :london, completed_at: Date.today + 2.years)
      create(:conversion_project, region: :south_east)
      create(:conversion_project, region: :london, completed_at: Date.today + 2.years, directive_academy_order: true)
      create(:conversion_project, region: :london, completed_at: nil, directive_academy_order: true)
      create(:conversion_project, region: :london, assigned_to: nil)

      statistics = subject.statistics_for_region(:london)

      expect(statistics.total).to eql(5)
      expect(statistics.in_progress).to eql(2)
      expect(statistics.completed).to eql(2)
      expect(statistics.unassigned).to eql(1)
    end
  end

  describe "Projects opening in the next 6 months" do
    describe "#opener_date_and_project_total" do
      let!(:project_1) { create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 1.month, conversion_date_provisional: false) }
      let!(:project_2) { create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 3.month, conversion_date_provisional: false) }

      it "returns the table of openers for the next 6 months" do
        (1..6).each do |i|
          date = Date.today + i.month
          within("##{Date::MONTHNAMES[date.month]}_#{date.year}") do
            expect(page).to have_content(Project.confirmed.filtered_by_significant_date(date.month, date.year).count)
          end
        end
      end
    end
  end
end
