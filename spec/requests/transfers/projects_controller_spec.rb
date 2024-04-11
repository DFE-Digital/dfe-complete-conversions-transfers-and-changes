require "rails_helper"

RSpec.describe All::ByMonth::Transfers::ProjectsController do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:project_form) { build(:create_transfer_project_form) }
  let(:project_form_params) {
    attributes_for(:create_project_form,
      "advisory_board_date(3i)": "1",
      "advisory_board_date(2i)": "1",
      "advisory_board_date(1i)": "2022",
      regional_delivery_officer: nil)
  }

  describe "#create" do
    let(:project) { build(:transfer_project) }

    before do
      mock_all_academies_api_responses
      sign_in_with(regional_delivery_officer)
    end

    subject(:perform_request) do
      post transfers_path, params: {transfer_create_project_form: {**project_form_params}}
      response
    end

    context "when the project is not valid" do
      before do
        allow(Transfer::CreateProjectForm).to receive(:new).and_return(project_form)
        allow(project_form).to receive(:valid?).and_return false
      end

      it "re-renders the new template" do
        expect(perform_request).to render_template :new
      end
    end
  end

  describe "#update" do
    before do
      sign_in_with(regional_delivery_officer)
    end

    it "shows an error when the change is invalid" do
      mock_successful_api_response_to_create_any_project
      project = create(:transfer_project, assigned_to: regional_delivery_officer)

      post transfers_update_path(project), params: {transfer_edit_project_form: {establishment_sharepoint_link: ""}}

      expect(response).to render_template(:edit)
    end
  end
end
