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

  describe "Regional casework services projects" do
    let!(:voluntary_in_progress_project_with_regional_casework_services_1) { create(:conversion_project, assigned_to_regional_caseworker_team: true, completed_at: nil) }
    let!(:voluntary_completed_project_with_regional_casework_services_2) { create(:conversion_project, assigned_to_regional_caseworker_team: true, completed_at: Date.today + 2.years) }
    let!(:sponsored_in_progress_project_with_regional_casework_services_1) { create(:involuntary_conversion_project, assigned_to_regional_caseworker_team: true, completed_at: nil) }
    let!(:sponsored_completed_project_with_regional_casework_services_2) { create(:involuntary_conversion_project, assigned_to_regional_caseworker_team: true, completed_at: Date.today + 2.years) }

    describe "#total_projects_with_regional_casework_services" do
      it "returns the total number of all projects within regional casework services" do
        expect(subject.total_projects_with_regional_casework_services).to eql(4)
      end
    end

    describe "#voluntary_projects_with_regional_casework_services" do
      it "returns the total number of voluntary projects within regional casework services" do
        expect(subject.voluntary_projects_with_regional_casework_services).to eql(2)
      end
    end

    describe "#sponsored_projects_with_regional_casework_services" do
      it "returns the total number of sponsored projects within regional casework services" do
        expect(subject.sponsored_projects_with_regional_casework_services).to eql(2)
      end
    end

    describe "#in_progress_projects_with_regional_casework_services" do
      it "returns the total number of in-progress projects within regional casework services" do
        expect(subject.in_progress_projects_with_regional_casework_services).to eql(2)
      end
    end

    describe "#completed_projects_with_regional_casework_services" do
      it "returns the total number of completed projects within regional casework services" do
        expect(subject.completed_projects_with_regional_casework_services).to eql(2)
      end
    end
  end

  describe "Regional projects that are not with regional casework services" do
    let!(:voluntary_in_progress_project_not_with_regional_casework_services_1) { create(:conversion_project, assigned_to_regional_caseworker_team: false, completed_at: nil) }
    let!(:voluntary_completed_project_not_with_regional_casework_services_2) { create(:conversion_project, assigned_to_regional_caseworker_team: false, completed_at: Date.today + 2.years) }
    let!(:sponsored_in_progress_project_not_with_regional_casework_services_1) { create(:involuntary_conversion_project, assigned_to_regional_caseworker_team: false, completed_at: nil) }
    let!(:sponsored_completed_project_not_with_regional_casework_services_2) { create(:involuntary_conversion_project, assigned_to_regional_caseworker_team: false, completed_at: Date.today + 2.years) }

    describe "#total_projects_not_with_regional_casework_services" do
      it "returns the total number of projects not with regional casework services" do
        expect(subject.total_projects_not_with_regional_casework_services).to eql(4)
      end
    end

    describe "#voluntary_projects_not_with_regional_casework_services" do
      it "returns the total number of voluntary projects not with regional casework services" do
        expect(subject.voluntary_projects_not_with_regional_casework_services).to eql(2)
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
  end

  describe "Projects per region" do
    context "within the London region" do
      let!(:voluntary_project_within_london_region_1) { create(:conversion_project, region: "london", completed_at: nil) }
      let!(:voluntary_project_within_london_region_2) { create(:conversion_project, region: "london", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_south_east_region_1) { create(:conversion_project, region: "south_east") }
      let!(:involuntary_project_within_london_region_1) { create(:involuntary_conversion_project, region: "london", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_london_region_2) { create(:involuntary_conversion_project, region: "london", completed_at: nil) }

      describe "#total_projects_within_london_region" do
        it "returns the total number of projects within the London region" do
          expect(subject.total_projects_within_london_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_london_region" do
        it "returns the total number of voluntary projects within the London region" do
          expect(subject.voluntary_projects_within_london_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_london_region" do
        it "returns the total number of sponsored projects within London region" do
          expect(subject.sponsored_projects_within_london_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_london_region" do
        it "returns the total number of in-progress projects within London region" do
          expect(subject.in_progress_projects_within_london_region).to eql(2)
        end
      end

      describe "#completed_projects_within_london_region" do
        it "returns the total number of completed projects within London regions" do
          expect(subject.completed_projects_within_london_region).to eql(2)
        end
      end
    end

    context "within the South East region" do
      let!(:voluntary_project_within_south_east_region_1) { create(:conversion_project, region: "south_east", completed_at: nil) }
      let!(:voluntary_project_within_south_east_region_2) { create(:conversion_project, region: "south_east", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_north_west_region_1) { create(:conversion_project, region: "north_west") }
      let!(:involuntary_project_within_south_east_region_1) { create(:involuntary_conversion_project, region: "south_east", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_south_east_region_2) { create(:involuntary_conversion_project, region: "south_east", completed_at: nil) }

      describe "#total_projects_within_south_east_region" do
        it "returns the total number of projects within the South East region" do
          expect(subject.total_projects_within_south_east_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_south_east_region" do
        it "returns the total number of voluntary projects within the South East region" do
          expect(subject.voluntary_projects_within_south_east_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_south_east_region" do
        it "returns the total number of sponsored projects within South East region" do
          expect(subject.sponsored_projects_within_south_east_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_south_east_region" do
        it "returns the total number of in-progress projects within South East region" do
          expect(subject.in_progress_projects_within_south_east_region).to eql(2)
        end
      end

      describe "#completed_projects_within_south_east_region" do
        it "returns the total number of completed projects within South East regions" do
          expect(subject.completed_projects_within_south_east_region).to eql(2)
        end
      end
    end

    context "within the Yorkshire and the Humber region" do
      let!(:voluntary_project_within_yorkshire_and_the_humber_region_1) { create(:conversion_project, region: "yorkshire_and_the_humber", completed_at: nil) }
      let!(:voluntary_project_within_yorkshire_and_the_humber_region_2) { create(:conversion_project, region: "yorkshire_and_the_humber", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_north_west_region_1) { create(:conversion_project, region: "north_west") }
      let!(:involuntary_project_within_yorkshire_and_the_humber_region_1) { create(:involuntary_conversion_project, region: "yorkshire_and_the_humber", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_yorkshire_and_the_humber_region_2) { create(:involuntary_conversion_project, region: "yorkshire_and_the_humber", completed_at: nil) }

      describe "#total_projects_within_yorkshire_and_the_humber_region" do
        it "returns the total number of projects within the Yorkshire and the Humber region" do
          expect(subject.total_projects_within_yorkshire_and_the_humber_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_yorkshire_and_the_humber_region" do
        it "returns the total number of voluntary projects within the Yorkshire and the Humber region" do
          expect(subject.voluntary_projects_within_yorkshire_and_the_humber_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_yorkshire_and_the_humber_region" do
        it "returns the total number of sponsored projects within Yorkshire and the Humber region" do
          expect(subject.sponsored_projects_within_yorkshire_and_the_humber_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_yorkshire_and_the_humber_region" do
        it "returns the total number of in-progress projects within Yorkshire and the Humber region" do
          expect(subject.in_progress_projects_within_yorkshire_and_the_humber_region).to eql(2)
        end
      end

      describe "#completed_projects_within_yorkshire_and_the_humber_region" do
        it "returns the total number of completed projects within Yorkshire and the Humber regions" do
          expect(subject.completed_projects_within_yorkshire_and_the_humber_region).to eql(2)
        end
      end
    end

    context "within the North West region" do
      let!(:voluntary_project_within_north_west_region_1) { create(:conversion_project, region: "north_west", completed_at: nil) }
      let!(:voluntary_project_within_north_west_region_2) { create(:conversion_project, region: "north_west", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_london_region_1) { create(:conversion_project, region: "london") }
      let!(:involuntary_project_within_north_west_region_1) { create(:involuntary_conversion_project, region: "north_west", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_north_west_region_2) { create(:involuntary_conversion_project, region: "north_west", completed_at: nil) }

      describe "#total_projects_within_north_west_region" do
        it "returns the total number of projects within the North West region" do
          expect(subject.total_projects_within_north_west_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_north_west_region" do
        it "returns the total number of voluntary projects within the North West region" do
          expect(subject.voluntary_projects_within_north_west_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_north_west_region" do
        it "returns the total number of sponsored projects within North West region" do
          expect(subject.sponsored_projects_within_north_west_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_north_west_region" do
        it "returns the total number of in-progress projects within North West region" do
          expect(subject.in_progress_projects_within_north_west_region).to eql(2)
        end
      end

      describe "#completed_projects_within_north_west_region" do
        it "returns the total number of completed projects within North West regions" do
          expect(subject.completed_projects_within_north_west_region).to eql(2)
        end
      end
    end

    context "within the East of England region" do
      let!(:voluntary_project_within_east_of_england_region_1) { create(:conversion_project, region: "east_of_england", completed_at: nil) }
      let!(:voluntary_project_within_east_of_england_region_2) { create(:conversion_project, region: "east_of_england", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_london_region_1) { create(:conversion_project, region: "london") }
      let!(:involuntary_project_within_east_of_england_region_1) { create(:involuntary_conversion_project, region: "east_of_england", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_east_of_england_region_2) { create(:involuntary_conversion_project, region: "east_of_england", completed_at: nil) }

      describe "#total_projects_within_east_of_england_region" do
        it "returns the total number of projects within the East of England region" do
          expect(subject.total_projects_within_east_of_england_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_east_of_england_region" do
        it "returns the total number of voluntary projects within the East of England region" do
          expect(subject.voluntary_projects_within_east_of_england_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_east_of_england_region" do
        it "returns the total number of sponsored projects within East of England region" do
          expect(subject.sponsored_projects_within_east_of_england_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_east_of_england_region" do
        it "returns the total number of in-progress projects within East of England region" do
          expect(subject.in_progress_projects_within_east_of_england_region).to eql(2)
        end
      end

      describe "#completed_projects_within_east_of_england_region" do
        it "returns the total number of completed projects within East of England regions" do
          expect(subject.completed_projects_within_east_of_england_region).to eql(2)
        end
      end
    end

    context "within the West Midlands region" do
      let!(:voluntary_project_within_west_midlands_region_1) { create(:conversion_project, region: "west_midlands", completed_at: nil) }
      let!(:voluntary_project_within_west_midlands_region_2) { create(:conversion_project, region: "west_midlands", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_london_region_1) { create(:conversion_project, region: "london") }
      let!(:involuntary_project_within_west_midlands_region_1) { create(:involuntary_conversion_project, region: "west_midlands", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_west_midlands_region_2) { create(:involuntary_conversion_project, region: "west_midlands", completed_at: nil) }

      describe "#total_projects_within_west_midlands_region" do
        it "returns the total number of projects within the West Midlands region" do
          expect(subject.total_projects_within_west_midlands_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_west_midlands_region" do
        it "returns the total number of voluntary projects within the West Midlands region" do
          expect(subject.voluntary_projects_within_west_midlands_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_west_midlands_region" do
        it "returns the total number of sponsored projects within West Midlands region" do
          expect(subject.sponsored_projects_within_west_midlands_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_west_midlands_region" do
        it "returns the total number of in-progress projects within West Midlands region" do
          expect(subject.in_progress_projects_within_west_midlands_region).to eql(2)
        end
      end

      describe "#completed_projects_within_west_midlands_region" do
        it "returns the total number of completed projects within West Midlands regions" do
          expect(subject.completed_projects_within_west_midlands_region).to eql(2)
        end
      end
    end

    context "within the North East region" do
      let!(:voluntary_project_within_north_east_region_1) { create(:conversion_project, region: "north_east", completed_at: nil) }
      let!(:voluntary_project_within_north_east_region_2) { create(:conversion_project, region: "north_east", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_london_region_1) { create(:conversion_project, region: "london") }
      let!(:involuntary_project_within_north_east_region_1) { create(:involuntary_conversion_project, region: "north_east", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_north_east_region_2) { create(:involuntary_conversion_project, region: "north_east", completed_at: nil) }

      describe "#total_projects_within_north_east_region" do
        it "returns the total number of projects within the North East region" do
          expect(subject.total_projects_within_north_east_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_north_east_region" do
        it "returns the total number of voluntary projects within the North East region" do
          expect(subject.voluntary_projects_within_north_east_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_north_east_region" do
        it "returns the total number of sponsored projects within North East region" do
          expect(subject.sponsored_projects_within_north_east_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_north_east_region" do
        it "returns the total number of in-progress projects within North East region" do
          expect(subject.in_progress_projects_within_north_east_region).to eql(2)
        end
      end

      describe "#completed_projects_within_north_east_region" do
        it "returns the total number of completed projects within North East regions" do
          expect(subject.completed_projects_within_north_east_region).to eql(2)
        end
      end
    end

    context "within the South West region" do
      let!(:voluntary_project_within_south_west_region_1) { create(:conversion_project, region: "south_west", completed_at: nil) }
      let!(:voluntary_project_within_south_west_region_2) { create(:conversion_project, region: "south_west", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_london_region_1) { create(:conversion_project, region: "london") }
      let!(:involuntary_project_within_south_west_region_1) { create(:involuntary_conversion_project, region: "south_west", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_south_west_region_2) { create(:involuntary_conversion_project, region: "south_west", completed_at: nil) }

      describe "#total_projects_within_south_west_region" do
        it "returns the total number of projects within the South West region" do
          expect(subject.total_projects_within_south_west_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_south_west_region" do
        it "returns the total number of voluntary projects within the South West region" do
          expect(subject.voluntary_projects_within_south_west_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_south_west_region" do
        it "returns the total number of sponsored projects within South West region" do
          expect(subject.sponsored_projects_within_south_west_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_south_west_region" do
        it "returns the total number of in-progress projects within South West region" do
          expect(subject.in_progress_projects_within_south_west_region).to eql(2)
        end
      end

      describe "#completed_projects_within_south_west_region" do
        it "returns the total number of completed projects within South West regions" do
          expect(subject.completed_projects_within_south_west_region).to eql(2)
        end
      end
    end

    context "within the East Midlands region" do
      let!(:voluntary_project_within_east_midlands_region_1) { create(:conversion_project, region: "east_midlands", completed_at: nil) }
      let!(:voluntary_project_within_east_midlands_region_2) { create(:conversion_project, region: "east_midlands", completed_at: Date.today + 2.years) }
      let!(:voluntary_project_within_london_region_1) { create(:conversion_project, region: "london") }
      let!(:involuntary_project_within_east_midlands_region_1) { create(:involuntary_conversion_project, region: "east_midlands", completed_at: Date.today + 2.years) }
      let!(:involuntary_project_within_east_midlands_region_2) { create(:involuntary_conversion_project, region: "east_midlands", completed_at: nil) }

      describe "#total_projects_within_east_midlands_region" do
        it "returns the total number of projects within the East Midlands region" do
          expect(subject.total_projects_within_east_midlands_region).to eql(4)
        end
      end

      describe "#voluntary_projects_within_east_midlands_region" do
        it "returns the total number of voluntary projects within the East Midlands region" do
          expect(subject.voluntary_projects_within_east_midlands_region).to eql(2)
        end
      end

      describe "#sponsored_projects_within_east_midlands_region" do
        it "returns the total number of sponsored projects within East Midlands region" do
          expect(subject.sponsored_projects_within_east_midlands_region).to eql(2)
        end
      end

      describe "#in_progress_projects_within_east_midlands_region" do
        it "returns the total number of in-progress projects within East Midlands region" do
          expect(subject.in_progress_projects_within_east_midlands_region).to eql(2)
        end
      end

      describe "#completed_projects_within_east_midlands_region" do
        it "returns the total number of completed projects within East Midlands regions" do
          expect(subject.completed_projects_within_east_midlands_region).to eql(2)
        end
      end
    end
  end
end
