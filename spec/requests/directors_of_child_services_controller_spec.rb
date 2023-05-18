require "rails_helper"

RSpec.describe LocalAuthoritiesController, type: :request do
  before do
    sign_in_with(user)
  end

  let(:director) { create(:director_of_child_services) }

  describe "#edit" do
    context "when the user is NOT a service support user" do
      let(:user) { create(:user, :caseworker) }

      it "does not allow the user to edit" do
        get edit_director_of_child_services_path(director)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    context "when the user is a service support user" do
      let(:user) { create(:user, service_support: true) }

      it "shows the edit form to the user" do
        get edit_director_of_child_services_path(director)
        expect(response.body).to include("Update contact details for #{director.local_authority.name}&#39;s DCS")
      end
    end
  end

  describe "#update" do
    let(:params) { {contact_director_of_child_services: {name: "John Director", email: "john@council.gov.uk"}} }

    subject(:perform_request) do
      put director_of_child_services_path(director), params: params
      response
    end

    context "when the user is NOT a service support user" do
      let(:user) { create(:user, :caseworker) }

      it "does not allow the user to update" do
        perform_request
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    context "when the user is a service support user" do
      let(:user) { create(:user, service_support: true) }

      context "and the params are valid" do
        it "allows the user to update the director of child services" do
          perform_request
          expect(subject).to redirect_to(directors_of_child_services_path)

          director.reload
          expect(director.name).to eq "John Director"
        end
      end

      context "and the params are not valid" do
        let(:params) { {contact_director_of_child_services: {name: "", email: ""}} }

        it "re-renders the edit page with an error message" do
          perform_request
          expect(response.body).to include("There is a problem")
        end
      end
    end
  end
end
