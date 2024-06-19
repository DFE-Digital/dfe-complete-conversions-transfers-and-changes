require "rails_helper"

RSpec.describe DateHistoryController do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "#create" do
    context "when the project is a conversion" do
      let(:project) {
        create(
          :conversion_project,
          conversion_date: Date.today.at_beginning_of_month + 1.month,
          conversion_date_provisional: false,
          assigned_to: user
        )
      }

      it "renders the earlier conversion form when the revised date is earlier" do
        post project_date_history_path(project), params: {new_date_history_form: {revised_date: project.conversion_date - 3.months}}

        expect(response).to render_template "date_history/reasons/earlier/new"
        expect(response.body).to include "Reasons for conversion date change"
      end

      it "renders the later converison form when the revised date is later" do
        post project_date_history_path(project), params: {new_date_history_form: {revised_date: project.conversion_date + 3.months}}

        expect(response).to render_template "date_history/reasons/later/new"
        expect(response.body).to include "Reasons for conversion date change"
      end
    end

    context "when the project is a transfer" do
      let(:project) {
        create(
          :transfer_project,
          transfer_date: Date.today.at_beginning_of_month + 1.month,
          transfer_date_provisional: false,
          assigned_to: user
        )
      }
      it "renders the earlier transfer form when the revised date is earlier" do
        post project_date_history_path(project), params: {new_date_history_form: {revised_date: project.transfer_date - 3.months}}

        expect(response).to render_template "date_history/reasons/earlier/new"
        expect(response.body).to include "Reasons for transfer date change"
      end

      it "renders the later transfer form when the revised date is later" do
        post project_date_history_path(project), params: {new_date_history_form: {revised_date: project.transfer_date + 3.months}}

        expect(response).to render_template "date_history/reasons/later/new"
        expect(response.body).to include "Reasons for transfer date change"
      end
    end

    it "renders the new action when the form is invalid" do
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false, assigned_to: user)

      post project_date_history_path(project), params: {new_date_history_form: {revised_date: nil}}

      expect(response).to render_template :new
    end
  end
end
