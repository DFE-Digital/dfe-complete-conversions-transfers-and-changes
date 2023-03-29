require "rails_helper"

RSpec.describe Conversion::Voluntary::TaskList do
  let(:task_class) { Conversion::Voluntary::Tasks::Handover }
  let(:task_list) {
    Conversion::Voluntary::TaskList.create!(
      handover_review: true
    )
  }

  it_behaves_like "a task list"

  describe "#locales_path" do
    it "returns the appropriate locales path based on the class path" do
      expect(task_list.locales_path).to eq "conversion.voluntary.task_list"
    end
  end

  describe "conversion date" do
    let(:user) { create(:user, :caseworker) }

    context "when the projects task list is saved" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "syncs the conversion date with the project and creates a date history" do
        conversion_date = Date.today.at_beginning_of_month - 6.months
        revised_conversion_date = Date.today.at_beginning_of_month
        project = create(:voluntary_conversion_project, conversion_date: conversion_date, conversion_date_provisional: true)

        project.task_list.update(stakeholder_kick_off_confirmed_conversion_date: revised_conversion_date, user: user)
        project.reload

        expect(project.conversion_date).to eq revised_conversion_date
        expect(project.conversion_date_provisional).to eq false

        conversion_date_history = project.conversion_dates.first
        expect(conversion_date_history.revised_date).to eql revised_conversion_date
        expect(conversion_date_history.previous_date).to eql conversion_date

        note = conversion_date_history.note
        expect(note.user).to eql user
        expect(note.project).to eql project
        expect(note.body).to eql I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.confirmed_conversion_date.note")
      end

      it "only syncs when the conversion date is provisional" do
        conversion_date = Date.today.at_beginning_of_month - 6.months
        revised_conversion_date = Date.today.at_beginning_of_month
        project = create(:voluntary_conversion_project, conversion_date: conversion_date, conversion_date_provisional: false)

        project.task_list.update(stakeholder_kick_off_confirmed_conversion_date: revised_conversion_date)

        expect(project.reload.conversion_date).to eq conversion_date
      end

      it "raises an error if no user is set on the task list" do
        conversion_date = Date.today.at_beginning_of_month - 6.months
        revised_conversion_date = Date.today.at_beginning_of_month
        project = create(:voluntary_conversion_project, conversion_date: conversion_date, conversion_date_provisional: true)

        expect {
          project.task_list.update(stakeholder_kick_off_confirmed_conversion_date: revised_conversion_date, user: nil)
        }.to raise_error(TaskList::Base::TaskListUserError)
      end

      it "does not create a date change note if there is no date submitted" do
        conversion_date = Date.today.at_beginning_of_month - 6.months
        project = create(:voluntary_conversion_project, conversion_date: conversion_date, conversion_date_provisional: true)

        note_count = project.notes.count
        project.task_list.update(stakeholder_kick_off_confirmed_conversion_date: nil)
        project.reload
        expect(project.notes.count).to eq note_count
      end
    end
  end
end
