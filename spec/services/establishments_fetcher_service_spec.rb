require "rails_helper"

RSpec.describe EstablishmentsFetcherService do
  describe "#call" do
    it "fetches the establishments and updates the projects" do
      api_client = Api::AcademiesApi::Client.new
      allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)
      allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([], nil))
      allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(double, nil))
      allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(double, nil))

      create(:conversion_project, establishment: nil)
      projects = Project.all
      described_class.new(projects).call!

      expect(projects.first.establishment).not_to be_nil
    end

    context "when there is a single batch of 10 projects or less" do
      it "calls the API once" do
        api_client = Api::AcademiesApi::Client.new
        allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)
        allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([], nil))
        allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(double, nil))
        allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(double, nil))

        create_list(:conversion_project, 6)
        projects = Project.all
        described_class.new(projects).call!

        expect(api_client).to have_received(:get_establishments).exactly(1).times
      end
    end

    context "whent there are multiple batches of projects" do
      it "calls the API the appropriate number of times" do
        api_client = Api::AcademiesApi::Client.new
        allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)
        allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([], nil))
        allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(double, nil))
        allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(double, nil))
        create_list(:conversion_project, 21)

        projects = Project.all
        described_class.new(projects).call!

        expect(api_client).to have_received(:get_establishments).exactly(2).times
      end
    end

    it "raises unless an ActiveRecord relation is passed in" do
      project = build(:conversion_project)

      expect { described_class.new([project]).call! }.to raise_error(ArgumentError)
    end

    it "returns nil if passed nil" do
      expect(described_class.new(nil).call!).to be_nil
    end

    it "returns nil if there are no projects" do
      expect(described_class.new([]).call!).to be_nil
    end
  end
end
