require "rails_helper"

RSpec.describe Transfers::ProjectsController do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:project_form) { build(:create_transfer_project_form) }
  let(:project_form_params) {
    attributes_for(:create_project_form,
      "advisory_board_date(3i)": "1",
      "advisory_board_date(2i)": "1",
      "advisory_board_date(1i)": "2022",
      "significant_date(3i)": "1",
      "significant_date(2i)": "1",
      "significant_date(1i)": Time.now.year + 1.year,
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
end
