require "rails_helper"

RSpec.describe All::Export::PreConversionGrantsController, type: :request do
  before do
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user) }

  describe "#new" do
    it "renders the new export form" do
      get new_all_export_pre_conversion_grants_path

      expect(response).to render_template :new
    end
  end

  describe "#create" do
    context "when the form is valid" do
      it "downloads the csv file" do
        post all_export_pre_conversion_grants_path, params: {export_new_pre_conversion_grants_form: {from_date: "2024-1-1", to_date: "2024-1-1"}}

        expect(response.status).to be 200
        expect(response.headers["Content-type"]).to eql "text/csv"
        expect(response.headers["Content-disposition"]).to include "pre_conversion_grants.csv"
      end
    end

    context "when the form is invalid" do
      it "renders the new form with a helpful error message" do
        post all_export_pre_conversion_grants_path, params: {export_new_pre_conversion_grants_form: {from_date: "2024-8-1", to_date: "2024-1-1"}}

        expect(response).to render_template :new
        expect(response.body).to include("There is a problem")
      end
    end
  end
end
