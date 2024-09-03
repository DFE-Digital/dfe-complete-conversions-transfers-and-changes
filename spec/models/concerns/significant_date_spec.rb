require "rails_helper"

RSpec.describe SignificantDate do
  before do
    mock_all_academies_api_responses
  end

  describe "validations" do
    describe "conversion_date" do
      it "must be present" do
        project = build(:conversion_project, conversion_date: nil)

        expect(project).to be_invalid
      end

      it "must be the 1st day of the month" do
        project = build(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 3.days)

        expect(project).to be_invalid
      end
    end
  end

  describe "scopes" do
    describe ".significant_date_revised_from" do
      let(:first_of_last_month) { Date.today.at_beginning_of_month - 1.month }
      let(:first_of_this_month) { Date.today.at_beginning_of_month }
      let(:first_of_future_month) { Date.today.at_beginning_of_month + 3.months }

      it "does not include projects whose conversion date stayed the same" do
        date_the_same_project = create(:conversion_project, conversion_date_provisional: false)
        create(:date_history, project: date_the_same_project, previous_date: first_of_this_month, revised_date: first_of_this_month)
        create(:date_history, project: date_the_same_project, previous_date: first_of_this_month, revised_date: first_of_this_month)

        matching_project = create(:conversion_project, conversion_date_provisional: false)
        create(:date_history, project: matching_project, previous_date: first_of_this_month - 1.month, revised_date: first_of_future_month)
        create(:date_history, project: matching_project, previous_date: first_of_this_month, revised_date: first_of_future_month)

        scoped_projects = Project.significant_date_revised_from(first_of_this_month.month, first_of_this_month.year)

        expect(scoped_projects).to include matching_project
        expect(scoped_projects).not_to include date_the_same_project
      end

      it "does not include projects where the only change is from provisional to confirmed and the dates are different" do
        project = create(:conversion_project, conversion_date_provisional: false, conversion_date: first_of_last_month)
        create(:date_history, project: project, previous_date: first_of_this_month, revised_date: first_of_future_month)

        scoped_projects = Project.significant_date_revised_from(first_of_this_month.month, first_of_this_month.year)

        expect(scoped_projects).not_to include project
      end

      it "only includes projects whose latest date history previous date is in the supplied month and year" do
        matching_project = create(:conversion_project, conversion_date_provisional: false)
        create(:date_history, project: matching_project, previous_date: first_of_this_month - 1.month, revised_date: first_of_this_month)
        create(:date_history, project: matching_project, previous_date: first_of_this_month, revised_date: first_of_future_month)

        not_matching_project = create(:conversion_project, conversion_date_provisional: false)
        create(:date_history, project: not_matching_project, previous_date: first_of_future_month, revised_date: first_of_future_month + 3.months)
        create(:date_history, project: not_matching_project, previous_date: first_of_this_month + 3.months, revised_date: first_of_future_month + 6.months)

        scoped_projects = Project.significant_date_revised_from(first_of_this_month.month, first_of_this_month.year)

        expect(scoped_projects).to include matching_project
        expect(scoped_projects).not_to include not_matching_project
      end
    end

    describe ".provisional" do
      it "only returns projects with a provisional conversion date" do
        provisional_project = create(:conversion_project, conversion_date_provisional: true)
        confirmed_project = create(:conversion_project, conversion_date_provisional: false)

        scoped_projects = Project.provisional

        expect(scoped_projects).to include provisional_project
        expect(scoped_projects).not_to include confirmed_project
      end
    end

    describe ".confirmed" do
      it "only returns projects with a confirmed conversion date" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        provisional_project = create(:conversion_project, conversion_date_provisional: true)
        confirmed_project = create(:conversion_project, conversion_date_provisional: false)

        scoped_projects = Project.confirmed

        expect(scoped_projects).to include confirmed_project
        expect(scoped_projects).not_to include provisional_project
      end
    end

    describe ".ordered_by_significant_date" do
      it "shows the project that will convert earliest first" do
        last_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 3.years)
        middle_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 2.years)
        first_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 1.year)

        scoped_projects = Project.ordered_by_significant_date

        expect(scoped_projects[0].id).to eq first_project.id
        expect(scoped_projects[1].id).to eq middle_project.id
        expect(scoped_projects[2].id).to eq last_project.id
      end
    end

    describe ".filtered_by_significant_date" do
      it "only returns projects with a significant date for the given month and year" do
        matching_project = create(:conversion_project, significant_date: Date.parse("2023-1-1"))
        other_project = create(:conversion_project, significant_date: Date.parse("2023-10-1"))

        scoped_projects = Project.filtered_by_significant_date(1, 2023)

        expect(scoped_projects).to include(matching_project)
        expect(scoped_projects).to_not include(other_project)
      end
    end

    describe ".significant_date_in_range" do
      it "only returns projects with a significant date within the given range of dates" do
        january = Date.parse("2023-1-1")
        february = Date.parse("2023-2-1")
        march = Date.parse("2023-3-1")
        october = Date.parse("2023-10-1")

        matching_project_1 = create(:conversion_project, significant_date: january, significant_date_provisional: false)
        create(:date_history, project: matching_project_1, previous_date: january, revised_date: february)

        matching_project_2 = create(:conversion_project, significant_date: february, significant_date_provisional: false)
        create(:date_history, project: matching_project_2, previous_date: february, revised_date: february)

        matching_project_3 = create(:transfer_project, significant_date: january, significant_date_provisional: false)
        create(:date_history, project: matching_project_3, previous_date: january, revised_date: march)

        other_project = create(:conversion_project, significant_date: october, significant_date_provisional: false)
        create(:date_history, project: other_project, previous_date: october, revised_date: october)

        scoped_projects = Project.significant_date_in_range(Date.parse("2023-1-1"), Date.parse("2023-3-1"))

        expect(scoped_projects).to include(matching_project_1, matching_project_2, matching_project_3)
      end
    end
  end

  describe "#provisional_date" do
    context "when there are no significant date histories" do
      it "returns the provisional date for a project" do
        project = build(:conversion_project, conversion_date: Date.today)

        expect(project.provisional_date).to eql Date.today
      end
    end

    context "when here are significant date histories" do
      it "returns the previous value from the earliest significant date history" do
        project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 6.months)
        first_date_history = create(:date_history, project: project, previous_date: Date.today.at_beginning_of_month + 2.months)
        _second_date_history = create(:date_history, project: project, previous_date: Date.today.at_beginning_of_month + 4.months)

        expect(project.provisional_date).to eql first_date_history.previous_date
      end
    end
  end

  describe "#confirmed_date_and_in_the_past?" do
    it "returns true when the significant date is confirmed and in the past" do
      matching_project = build(:conversion_project, conversion_date: Date.today.at_beginning_of_month - 1.month, conversion_date_provisional: false)
      not_past_project = build(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 1.month, conversion_date_provisional: false)
      not_confirmed_project = build(:conversion_project, conversion_date: Date.today.at_beginning_of_month - 2.months, conversion_date_provisional: true)

      expect(matching_project.confirmed_date_and_in_the_past?).to be true
      expect(not_past_project.confirmed_date_and_in_the_past?).to be false
      expect(not_confirmed_project.confirmed_date_and_in_the_past?).to be false
    end
  end
end
