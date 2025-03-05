require "rails_helper"

RSpec.describe ByLocalAuthorityProjectFetcherService do
  before do
    cumbria_establishment = build(:academies_api_establishment, local_authority_code: "909", urn: 121813)
    cumbria_establishment2 = build(:academies_api_establishment, local_authority_code: "909", urn: 222222)
    cumbria_establishment3 = build(:academies_api_establishment, local_authority_code: "909", urn: 333333)
    westminster_establishment = build(:academies_api_establishment, local_authority_code: "213", urn: 121102)
    norfolk_establishment = build(:academies_api_establishment, local_authority_code: "926", urn: 121583)

    fake_client = double(Api::AcademiesApi::Client,
      get_trust: Api::AcademiesApi::Client::Result.new(double, nil))

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)

    allow(fake_client).to receive(:get_establishment).with(cumbria_establishment.urn)
      .and_return(Api::AcademiesApi::Client::Result.new(cumbria_establishment, nil))

    allow(fake_client).to receive(:get_establishment).with(cumbria_establishment2.urn)
      .and_return(Api::AcademiesApi::Client::Result.new(cumbria_establishment2, nil))

    allow(fake_client).to receive(:get_establishment).with(cumbria_establishment3.urn)
      .and_return(Api::AcademiesApi::Client::Result.new(cumbria_establishment3, nil))

    allow(fake_client).to receive(:get_establishment).with(westminster_establishment.urn)
      .and_return(Api::AcademiesApi::Client::Result.new(westminster_establishment, nil))

    allow(fake_client).to receive(:get_establishment).with(norfolk_establishment.urn)
      .and_return(Api::AcademiesApi::Client::Result.new(norfolk_establishment, nil))

    allow(fake_client).to receive(:get_establishments).with(any_args)
      .and_return(Api::AcademiesApi::Client::Result.new([
        cumbria_establishment,
        cumbria_establishment2,
        cumbria_establishment3,
        westminster_establishment,
        norfolk_establishment
      ], nil))

    allow(fake_client).to receive(:get_trusts)
      .and_return(Api::AcademiesApi::Client::Result.new([double("Trust", ukprn: 10010010)], nil))

    cumbria = create(:local_authority, code: "909", name: "Cumbria County Council")
    westminster = create(:local_authority, code: "213", name: "Westminster City Council")
    norfolk = create(:local_authority, code: "926", name: "Norfolk County Council")

    create(:conversion_project, local_authority: cumbria, urn: cumbria_establishment.urn, conversion_date: Date.new(2024, 1, 1))
    create(:conversion_project, local_authority: westminster, urn: westminster_establishment.urn)
    create(:conversion_project, local_authority: cumbria, urn: cumbria_establishment2.urn, conversion_date: Date.new(2024, 2, 1))

    create(:transfer_project, local_authority: cumbria, urn: cumbria_establishment3.urn, transfer_date: Date.new(2024, 3, 1))
    create(:transfer_project, local_authority: norfolk, urn: norfolk_establishment.urn)
  end

  describe "#local_authorities_with_projects" do
    it "returns a sorted list of local authorities with counts of the projects for them" do
      result = described_class.new.local_authorities_with_projects

      expect(result.count).to eql 3

      first_result = result.first

      expect(first_result.name).to eql "Cumbria County Council"
      expect(first_result.code).to eql "909"
      expect(first_result.conversion_count).to eql 2
      expect(first_result.transfer_count).to eql 1

      middle_result = result[1]

      expect(middle_result.name).to eql "Norfolk County Council"
      expect(middle_result.code).to eql "926"
      expect(middle_result.conversion_count).to eql 0
      expect(middle_result.transfer_count).to eql 1

      last_result = result.last

      expect(last_result.name).to eql "Westminster City Council"
      expect(last_result.code).to eql "213"
      expect(last_result.conversion_count).to eql 1
      expect(last_result.transfer_count).to eql 0
    end

    it "returns an empty array when there are no projects to source local authorities" do
      allow(Project).to receive(:active).and_return(Project.none)

      expect(described_class.new.local_authorities_with_projects).to eql []
    end
  end

  describe "#projects_for_local_authority" do
    it "returns a sorted list of projects for the supplied local authority" do
      projects_for_local_authority = described_class.new.projects_for_local_authority("909")

      expect(projects_for_local_authority.count).to eql 3
      expect(projects_for_local_authority.first.conversion_date).to eql Date.new(2024, 1, 1)
      expect(projects_for_local_authority.last.transfer_date).to eql Date.new(2024, 3, 1)
    end

    it "returns an empty AR relation when there are no projects for the supplied local authority code" do
      unused_local_authority = create(:local_authority)
      expect(described_class.new.projects_for_local_authority(unused_local_authority.code)).to be_empty
    end

    it "only fetches project and related date once" do
      spy = AcademiesApiPreFetcherService.new
      allow(AcademiesApiPreFetcherService).to receive(:new).and_return(spy)
      allow(spy).to receive(:call!).and_call_original

      result = described_class.new

      result.projects_for_local_authority("909")
      result.projects_for_local_authority("909")

      expect(spy).to have_received(:call!).once
    end
  end
end
