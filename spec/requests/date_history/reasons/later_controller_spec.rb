require "rails_helper"

RSpec.describe DateHistory::Reasons::LaterController do
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
          conversion_date: Date.today.at_beginning_of_month,
          conversion_date_provisional: false,
          assigned_to: user
        )
      }

      it "renders the conversion confirmation view when valid" do
        post project_date_history_reasons_later_path(project), params: {
          project: project,
          date_history_reasons_new_later_form: {
            revised_date: project.conversion_date + 1.month,
            correcting_an_error: "1",
            correcting_an_error_note: "I made an error."
          }
        }

        expect(response).to render_template "date_history/confirm_new"
        expect(response.body).to include "Conversion date changed"
      end

      it "renders the new action when the form is invalid" do
        post project_date_history_reasons_later_path(project), params: {
          project: project,
          date_history_reasons_new_later_form: {
            revised_date: project.conversion_date - 1.month
          }
        }

        expect(response).to render_template :new
      end
    end

    context "when the project is a transfer" do
      let(:project) {
        create(
          :transfer_project,
          transfer_date: Date.today.at_beginning_of_month,
          transfer_date_provisional: false,
          assigned_to: user
        )
      }

      it "renders the transfer confirmation view when valid" do
        post project_date_history_reasons_later_path(project), params: {
          project: project,
          date_history_reasons_new_later_form: {
            revised_date: project.transfer_date - 1.month,
            correcting_an_error: "1",
            correcting_an_error_note: "I made an error."
          }
        }

        expect(response).to render_template "date_history/confirm_new"
        expect(response.body).to include "Transfer date changed"
      end

      it "renders the new action when the form is invalid" do
        post project_date_history_reasons_later_path(project), params: {
          date_history_reasons_new_later_form: {
            revised_date: project.transfer_date - 1.month
          }
        }

        expect(response).to render_template :new
      end
    end
  end
end
