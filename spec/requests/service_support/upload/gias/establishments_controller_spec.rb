require "rails_helper"

RSpec.describe ServiceSupport::Upload::Gias::EstablishmentsController, type: :request do
  let(:user) { create(:service_support_user) }

  before do
    sign_in_with(user)
  end

  describe "#new" do
    it "allows a service support user to see the upload form" do
      get "/service-support/upload/gias/establishments/new"
      expect(response).to have_http_status(:success)
    end

    context "with a non service support user" do
      let(:user) { create(:user) }

      it "does not allow the user to see the upload form" do
        get "/service-support/upload/gias/establishments/new"
        expect(response).not_to render_template(:new)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end
  end

  describe "#upload" do
    context "with a non service support user" do
      let(:user) { create(:user) }

      it "does not allow the user to upload" do
        params = {service_support_upload_gias_upload_establishments_form: {uploaded_file: fixture_file_upload("gias_establishment_data_good.csv", "text/csv")}}
        post "/service-support/upload/gias/establishments/upload", params: params

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    context "when the upload is successful" do
      before do
        allow_any_instance_of(ServiceSupport::Upload::Gias::UploadEstablishmentsForm).to receive(:save).and_return(true)
      end

      it "shows a success message" do
        params = {service_support_upload_gias_upload_establishments_form: {uploaded_file: fixture_file_upload("gias_establishment_data_good.csv", "text/csv")}}
        post "/service-support/upload/gias/establishments/upload", params: params

        expect(response).to redirect_to(service_support_upload_gias_establishments_new_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("service_support.import.gias_establishments.success", time: "0100"))
      end
    end

    context "when the upload fails" do
      it "shows a success message" do
        params = {service_support_upload_gias_upload_establishments_form: {uploaded_file: fixture_file_upload("gias_establishment_data_empty.csv", "text/csv")}}
        post "/service-support/upload/gias/establishments/upload", params: params

        expect(response).to have_http_status(:success)
        expect(response.body).to include(I18n.t("errors.upload.attributes.uploaded_file.empty_file"))
      end
    end
  end
end
