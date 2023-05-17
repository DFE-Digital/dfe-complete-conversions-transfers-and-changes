require "rails_helper"

RSpec.describe LocalAuthoritiesController, type: :request do
  let(:user) { create(:user, service_support: true) }

  before do
    sign_in_with(user)
  end

  describe "#create" do
    subject(:perform_request) do
      post local_authorities_path, params: params
      response
    end

    context "when we are only creating a Local Authority" do
      let(:params) { {local_authority: {name: "Bumbletown Council", code: rand(100..999), address_1: "1 Town Square", address_town: "Bumbletown", address_postcode: "BT1 1AA"}} }

      it "creates the local authority and redirects to the show page" do
        perform_request
        local_authority = LocalAuthority.last
        expect(subject).to redirect_to(local_authority_path(local_authority))
        expect(request.flash[:notice]).to eq(I18n.t("local_authority.create.success"))

        expect(LocalAuthority.count).to be 1
        expect(local_authority.name).to eq("Bumbletown Council")
      end
    end

    context "when we are creating a Director of Child Services at the same time as the Local Authority" do
      let(:params) { {local_authority: {name: "Bumbletown Council", code: rand(100..999), address_1: "1 Town Square", address_town: "Bumbletown", address_postcode: "BT1 1AA", director_of_child_services_attributes: {name: "Jane Director", title: "DCS", email: "jane.director@council.gov"}}} }

      it "creates the local authority and contact, and redirects to the show page" do
        perform_request
        local_authority = LocalAuthority.last
        expect(subject).to redirect_to(local_authority_path(local_authority))
        expect(request.flash[:notice]).to eq(I18n.t("local_authority.create.success"))

        expect(LocalAuthority.count).to be 1
        expect(local_authority.name).to eq("Bumbletown Council")

        expect(Contact::DirectorOfChildServices.count).to be 1
        expect(local_authority.director_of_child_services.name).to eq "Jane Director"
      end
    end
  end

  describe "#update" do
    let(:local_authority) { create(:local_authority) }
    let(:director_of_child_services) { create(:director_of_child_services, local_authority: local_authority) }

    subject(:perform_request) do
      put local_authority_path(local_authority.id), params: params
      response
    end

    context "when we are only updating a Local Authority" do
      let(:params) { {local_authority: {address_1: "1 Updated Address"}} }

      it "updates the local authority and redirects to the show page" do
        perform_request
        expect(subject).to redirect_to(local_authority_path(local_authority))

        local_authority.reload

        expect(local_authority.address_1).to eq "1 Updated Address"
      end
    end

    context "when we are updating a Director of Child Services at the same time as the Local Authority" do
      let(:params) { {local_authority: {address_1: "1 Updated Address", director_of_child_services_attributes: {name: "John Promotion", title: "Director of Child Services", email: "john.promotion@council.gov"}}} }

      it "updates the local authority and director of child services, and redirects to the show page" do
        perform_request
        expect(subject).to redirect_to(local_authority_path(local_authority))

        local_authority.reload

        expect(local_authority.address_1).to eq "1 Updated Address"
        expect(local_authority.director_of_child_services.name).to eq "John Promotion"
      end
    end
  end

  describe "#destroy" do
    let!(:local_authority) { create(:local_authority) }
    let!(:director_of_child_services) { create(:director_of_child_services, local_authority: local_authority) }

    it "destroys an associated director of child services with the local authority" do
      delete local_authority_path(local_authority.id)

      expect(LocalAuthority.count).to eq 0
      expect(Contact::DirectorOfChildServices.count).to eq 0
    end
  end
end
