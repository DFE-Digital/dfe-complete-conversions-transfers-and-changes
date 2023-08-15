require "rails_helper"

RSpec.describe Statistics::ProjectStatistics, type: :model do
  subject { Statistics::ProjectStatistics.new }
  before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

  describe "all projects" do
    before do
      create_list(:conversion_project, 2, assigned_to: nil)
      create(:conversion_project)
      create(:conversion_project, completed_at: Date.today)
      create_list(:transfer_project, 2, assigned_to: nil)
      create(:transfer_project)
      create(:transfer_project, completed_at: Date.today)
    end

    describe "#total_number_of_conversion_projects" do
      it "returns the total number of all conversion projects" do
        expect(subject.total_number_of_conversion_projects).to eql(4)
      end
    end

    describe "#total_number_of_transfer_projects" do
      it "returns the total number of all transfer projects" do
        expect(subject.total_number_of_transfer_projects).to eql(4)
      end
    end

    describe "#total_number_of_in_progress_conversion_projects" do
      it "returns the total number of all in-progress conversion projects" do
        expect(subject.total_number_of_in_progress_conversion_projects).to eql(1)
      end
    end

    describe "#total_number_of_in_progress_transfer_projects" do
      it "returns the total number of all in-progress transfer projects" do
        expect(subject.total_number_of_in_progress_transfer_projects).to eql(1)
      end
    end

    describe "#total_number_of_unassigned_conversion_projects" do
      it "returns the total number of all unassigned conversion projects" do
        expect(subject.total_number_of_unassigned_conversion_projects).to eql(2)
      end
    end

    describe "#total_number_of_unassigned_transfer_projects" do
      it "returns the total number of all unassigned transfer projects" do
        expect(subject.total_number_of_unassigned_transfer_projects).to eql(2)
      end
    end

    describe "#total_number_of_completed_conversion_projects" do
      it "returns the total number of all completed onversion projects" do
        expect(subject.total_number_of_completed_conversion_projects).to eql(1)
      end
    end

    describe "#total_number_of_completed_transfer_projects" do
      it "returns the total number of all completed transfer projects" do
        expect(subject.total_number_of_completed_transfer_projects).to eql(1)
      end
    end
  end

  describe "Regional casework services projects" do
    before do
      create(:conversion_project, team: :regional_casework_services, completed_at: nil)
      create(:conversion_project, team: :regional_casework_services, completed_at: Date.today + 2.years)
      create(:conversion_project, team: :regional_casework_services, assigned_to: nil)
      create(:conversion_project, team: :north_west, assigned_to: nil)

      create(:transfer_project, team: :regional_casework_services, completed_at: nil)
      create(:transfer_project, team: :regional_casework_services, completed_at: Date.today + 2.years)
      create(:transfer_project, team: :regional_casework_services, assigned_to: nil)
      create(:transfer_project, team: :north_west, assigned_to: nil)
    end

    describe "#total_conversion_projects_with_regional_casework_services" do
      it "returns the total number of all conversion projects within regional casework services" do
        expect(subject.total_conversion_projects_with_regional_casework_services).to eql(3)
      end
    end

    describe "#total_transfer_projects_with_regional_casework_services" do
      it "returns the total number of all transfer projects within regional casework services" do
        expect(subject.total_transfer_projects_with_regional_casework_services).to eql(3)
      end
    end

    describe "#in_progress_conversion_projects_with_regional_casework_services" do
      it "returns the total number of in-progress conversion projects within regional casework services" do
        expect(subject.in_progress_conversion_projects_with_regional_casework_services).to eql(1)
      end
    end

    describe "#in_progress_transfer_projects_with_regional_casework_services" do
      it "returns the total number of in-progress transfer projects within regional casework services" do
        expect(subject.in_progress_transfer_projects_with_regional_casework_services).to eql(1)
      end
    end

    describe "#completed_conversion_projects_with_regional_casework_services" do
      it "returns the total number of completed conversion projects within regional casework services" do
        expect(subject.completed_conversion_projects_with_regional_casework_services).to eql(1)
      end
    end

    describe "#completed_transfer_projects_with_regional_casework_services" do
      it "returns the total number of completed transfer projects within regional casework services" do
        expect(subject.completed_transfer_projects_with_regional_casework_services).to eql(1)
      end
    end

    describe "#unassigned_conversion_projects_with_regional_casework_services" do
      it "returns the total number of unassigned conversion projects within regional casework services" do
        expect(subject.unassigned_conversion_projects_with_regional_casework_services).to eql(1)
      end
    end

    describe "#unassigned_transfer_projects_with_regional_casework_services" do
      it "returns the total number of unassigned transfer projects within regional casework services" do
        expect(subject.unassigned_transfer_projects_with_regional_casework_services).to eql(1)
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

      create(:transfer_project, team: "london", completed_at: nil)
      create(:transfer_project, team: "london", completed_at: Date.today + 2.years)
      create(:transfer_project, team: "london", completed_at: nil, directive_academy_order: true)
      create(:transfer_project, team: "london", completed_at: Date.today + 2.years, directive_academy_order: true)
      create(:transfer_project, team: "london", assigned_to: nil)
    end

    describe "#total_conversion_projects_not_with_regional_casework_services" do
      it "returns the total number of conversion projects not with regional casework services" do
        expect(subject.total_conversion_projects_not_with_regional_casework_services).to eql(5)
      end
    end

    describe "#total_transfer_projects_not_with_regional_casework_services" do
      it "returns the total number of transfer projects not with regional casework services" do
        expect(subject.total_transfer_projects_not_with_regional_casework_services).to eql(5)
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

    describe "#in_progress_conversion_projects_not_with_regional_casework_services" do
      it "returns the total number of in-progress conversion projects not with regional casework services" do
        expect(subject.in_progress_conversion_projects_not_with_regional_casework_services).to eql(2)
      end
    end

    describe "#in_progress_transfer_projects_not_with_regional_casework_services" do
      it "returns the total number of in-progress transfer projects not with regional casework services" do
        expect(subject.in_progress_transfer_projects_not_with_regional_casework_services).to eql(2)
      end
    end

    describe "#completed_conversion_projects_not_with_regional_casework_services" do
      it "returns the total number of completed conversion projects not with regional casework services" do
        expect(subject.completed_conversion_projects_not_with_regional_casework_services).to eql(2)
      end
    end

    describe "#completed_transfer_projects_not_with_regional_casework_services" do
      it "returns the total number of completed transfer projects not with regional casework services" do
        expect(subject.completed_transfer_projects_not_with_regional_casework_services).to eql(2)
      end
    end

    describe "#unassigned_conversion_projects_not_with_regional_casework_services" do
      it "returns the total number of unassigned conversion projects not within regional casework services" do
        expect(subject.unassigned_conversion_projects_not_with_regional_casework_services).to eql(1)
      end
    end

    describe "#unassigned_transfer_projects_not_with_regional_casework_services" do
      it "returns the total number of unassigned transfer projects not within regional casework services" do
        expect(subject.unassigned_transfer_projects_not_with_regional_casework_services).to eql(1)
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
