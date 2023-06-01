require "rails_helper"

RSpec.describe Conversion::Project do
  before { mock_successful_api_response_to_create_any_project }

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

  describe "#opened?" do
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
end
