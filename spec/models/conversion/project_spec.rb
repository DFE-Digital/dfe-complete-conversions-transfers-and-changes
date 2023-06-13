require "rails_helper"

RSpec.describe Conversion::Project do
  before { mock_successful_api_response_to_create_any_project }

  describe "validations" do
    describe "academy urn" do
      context "when there is no academy urn" do
        it "is valid" do
          project = build(:conversion_project, academy_urn: nil)

          expect(project).to be_valid
        end
      end

      context "when there is an academy urn" do
        it "the urn must be valid" do
          project = build(:conversion_project, academy_urn: 12345678)

          expect(project).to be_invalid

          project = build(:conversion_project, academy_urn: 123456)

          expect(project).to be_valid
        end
      end
    end
  end

  describe "scopes" do
    describe ".no_academy_urn" do
      it "returns only projects where academy_urn is nil" do
        mock_successful_api_response_to_create_any_project
        new_project = create(:conversion_project, academy_urn: nil)
        existing_project = create(:conversion_project, academy_urn: 126041)
        projects = Conversion::Project.no_academy_urn

        expect(projects).to include(new_project)
        expect(projects).not_to include(existing_project)
      end
    end

    describe ".with_academy_urn" do
      it "returns only projects where academy_urn is NOT nil" do
        mock_successful_api_response_to_create_any_project
        new_project = create(:conversion_project, academy_urn: nil)
        existing_project = create(:conversion_project, academy_urn: 126041)
        projects = Conversion::Project.with_academy_urn

        expect(projects).to include(existing_project)
        expect(projects).not_to include(new_project)
      end
    end

    describe ".opening_by_month_year" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns projects with a confirmed conversion date" do
        conversion_project = create(:conversion_project)
        expect(Conversion::Project.opening_by_month_year(1, 2023)).to_not include(conversion_project)
      end

      it "only returns projects with a confirmed conversion date in that month & year" do
        project_in_scope = create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false)
        project_not_in_scope = create(:conversion_project, conversion_date: Date.new(2023, 2, 1), conversion_date_provisional: true)
        project_without_conversion_date = create(:conversion_project)

        expect(Conversion::Project.opening_by_month_year(1, 2023)).to_not include(project_not_in_scope, project_without_conversion_date)
        expect(Conversion::Project.opening_by_month_year(1, 2023)).to include(project_in_scope)
      end
    end

    describe ".provisional" do
      it "only returns projects with a provisional conversion date" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        provisional_project = create(:conversion_project, conversion_date_provisional: true)
        confirmed_project = create(:conversion_project, conversion_date_provisional: false)

        scoped_projects = Conversion::Project.provisional

        expect(scoped_projects).to include provisional_project
        expect(scoped_projects).not_to include confirmed_project
      end
    end

    describe ".confirmed" do
      it "only returns projects with a confirmed conversion date" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        provisional_project = create(:conversion_project, conversion_date_provisional: true)
        confirmed_project = create(:conversion_project, conversion_date_provisional: false)

        scoped_projects = Conversion::Project.confirmed

        expect(scoped_projects).to include confirmed_project
        expect(scoped_projects).not_to include provisional_project
      end
    end

    describe ".in_progress" do
      it "is ordered by conversion date ascending" do
        mock_successful_api_response_to_create_any_project
        create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 2.month)
        project_converting_last = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 3.month)
        project_converting_first = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 1.month)

        projects = Conversion::Project.in_progress

        expect(projects.first).to eql project_converting_first
        expect(projects.last).to eql project_converting_last
      end
    end

    describe ".by_conversion_date" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "shows the project that will convert earliest first" do
        last_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 3.years)
        middle_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 2.years)
        first_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 1.year)

        scoped_projects = Conversion::Project.by_conversion_date

        expect(scoped_projects[0].id).to eq first_project.id
        expect(scoped_projects[1].id).to eq middle_project.id
        expect(scoped_projects[2].id).to eq last_project.id
      end
    end
  end

  describe "#conversion_date" do
    it { is_expected.to validate_presence_of(:conversion_date) }

    context "when the date is not on the first of the month" do
      subject { build(:conversion_project, conversion_date: Date.today.months_since(6).at_end_of_month) }

      it "is invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:conversion_date]).to include(I18n.t("errors.attributes.conversion_date.must_be_first_of_the_month"))
      end
    end
  end

  describe "#route" do
    context "when a directive academy order has been issued" do
      context "and the school is joining a sponsor trust" do
        let(:project) { create(:conversion_project, directive_academy_order: true) }

        it "the route is sponsored" do
          expect(project.route).to eq :sponsored
        end
      end
    end

    context "when the project has not been issued a directive academy order" do
      context "and the school is joining a sponsor trust" do
        let(:project) { create(:conversion_project, directive_academy_order: false) }

        it "the route is voluntary" do
          expect(project.route).to eq :voluntary
        end
      end

      context "and the school is not joining a sponsor trust" do
        let(:project) { create(:conversion_project, directive_academy_order: false) }

        it "the route is voluntary" do
          expect(project.route).to eq :voluntary
        end
      end
    end
  end

  describe "#fetch_provisional_conversion_date" do
    context "when there are no conversion date histories" do
      it "returns the value in conversion_date" do
        project = build(:conversion_project, conversion_date: Date.today)

        expect(project.fetch_provisional_conversion_date).to eql Date.today
      end
    end

    context "whent here are conversion date histories" do
      context "when here are conversion date histories" do
        it "returns the previous value from the earliest conversion date history" do
          project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
          first_date_history = create(:date_history, project: project, previous_date: Date.today.at_beginning_of_month + 2.months)
          _second_date_history = create(:date_history, project: project, previous_date: Date.today.at_beginning_of_month + 4.months)

          expect(project.fetch_provisional_conversion_date).to eql first_date_history.previous_date
        end
      end
    end
  end

  describe "#all_conditions_met?" do
    context "when the all conditions met task is completed" do
      let(:tasks_data) { create(:conversion_tasks_data, conditions_met_confirm_all_conditions_met: true) }
      let(:project) { build(:conversion_project, tasks_data: tasks_data) }

      it "returns true" do
        expect(project.all_conditions_met?).to eq(true)
      end
    end

    context "when the all conditions met task has not been completed" do
      let(:tasks_data) { create(:conversion_tasks_data, conditions_met_confirm_all_conditions_met: nil) }
      let(:project) { build(:conversion_project, tasks_data: tasks_data) }

      it "returns false" do
        expect(project.all_conditions_met?).to eq(false)
      end
    end
  end

  describe "#conversion_date_confirmed_and_passed?" do
    let(:project) {
      build(:conversion_project,
        conversion_date: conversion_date,
        conversion_date_provisional: conversion_date_provisional)
    }

    context "when the conversion date has not passed" do
      let(:conversion_date) { Date.tomorrow }
      let(:conversion_date_provisional) { false }

      it "returns false" do
        expect(project.conversion_date_confirmed_and_passed?).to be false
      end
    end

    context "when the conversion date has passed but the conversion date is provisional" do
      let(:conversion_date) { Date.yesterday }
      let(:conversion_date_provisional) { true }

      it "returns false" do
        expect(project.conversion_date_confirmed_and_passed?).to be false
      end
    end

    context "when the conversion date is provisional" do
      let(:conversion_date) { Date.tomorrow }
      let(:conversion_date_provisional) { true }

      it "returns false" do
        expect(project.conversion_date_confirmed_and_passed?).to be false
      end
    end

    context "when the conversion date is confirmed and the conversion date has passed" do
      let(:conversion_date) { Date.yesterday }
      let(:conversion_date_provisional) { false }

      it "returns true" do
        expect(project.conversion_date_confirmed_and_passed?).to be true
      end
    end
  end

  describe "#grant_payment_certificate_received?" do
    let(:user) { create(:user) }
    let(:project) { build(:conversion_project, tasks_data: tasks_data) }

    context "when the ReceiveGrantPaymentCertificateTaskForm is NOT completed" do
      let(:tasks_data) {
        create(:conversion_tasks_data,
          receive_grant_payment_certificate_check_and_save: nil,
          receive_grant_payment_certificate_update_kim: nil,
          receive_grant_payment_certificate_update_sheet: nil)
      }

      it "returns false" do
        expect(project.grant_payment_certificate_received?).to be false
      end
    end

    context "when the ReceiveGrantPaymentCertificateTaskForm is completed" do
      let(:tasks_data) {
        create(:conversion_tasks_data,
          receive_grant_payment_certificate_check_and_save: true,
          receive_grant_payment_certificate_update_kim: true,
          receive_grant_payment_certificate_update_sheet: true)
      }

      it "returns true" do
        expect(project.grant_payment_certificate_received?).to be true
      end
    end
  end

  describe "#academy" do
    it "returns an establishment object when the urn can be found" do
      mock_successful_api_response_to_create_any_project

      project = build(:conversion_project, academy_urn: 123456)

      expect(project.academy).to be_a(Api::AcademiesApi::Establishment)
    end

    it "returns nil when the urn cannot be found" do
      mock_successful_api_response_to_create_any_project
      mock_establishment_not_found(urn: 999999)

      project = build(:conversion_project, academy_urn: 999999)

      expect(project.academy).to be_nil
    end
  end

  describe "#academy_found?" do
    before { mock_successful_api_response_to_create_any_project }

    it "returns true when the academy can be found" do
      project = build(:conversion_project, academy_urn: 123456)

      expect(project.academy_found?).to eql true
    end

    it "returns false when the academy cannot be found" do
      project = build(:conversion_project, academy_urn: 123456)

      allow_any_instance_of(Conversion::Project).to receive(:academy).and_return(nil)

      expect(project.academy_found?).to eql false
    end
  end

  describe ".conversion_date_revised_from" do
    let(:first_of_this_month) { Date.today.at_beginning_of_month }
    let(:first_of_future_month) { Date.today.at_beginning_of_month + 3.months }

    it "does not include projects whose conversion date stayed the same" do
      user = create(:user)
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: project, previous_date: first_of_this_month, revised_date: first_of_this_month)

      another_project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: another_project, previous_date: first_of_this_month, revised_date: first_of_future_month)

      projects = Conversion::Project.conversion_date_revised_from(first_of_this_month.month, first_of_this_month.year)

      expect(projects).to include another_project
      expect(projects).not_to include project
    end

    it "only includes projects whose latest date history previous date is in the supplied month and year" do
      user = create(:user)
      mock_successful_api_response_to_create_any_project

      another_project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: another_project, previous_date: first_of_this_month, revised_date: first_of_future_month)

      yet_another_project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: yet_another_project, previous_date: first_of_future_month, revised_date: first_of_future_month + 3.months)

      projects = Conversion::Project.conversion_date_revised_from(first_of_future_month.month, first_of_future_month.year)

      expect(projects).to include yet_another_project
      expect(projects).not_to include another_project
    end
  end
end
