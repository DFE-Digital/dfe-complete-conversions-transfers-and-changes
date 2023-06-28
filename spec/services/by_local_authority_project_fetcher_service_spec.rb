require "rails_helper"

RSpec.describe ByLocalAuthorityProjectFetcherService do
  it "returns a sorted list of simple local authority objects with projects" do
    establishment = build(:academies_api_establishment, local_authority_code: "909", urn: 121813)
    another_establishment = build(:academies_api_establishment, local_authority_code: "213", urn: 121102)
    yet_another_establishment = build(:academies_api_establishment, local_authority_code: "926", urn: 121583)

    fake_client = double(Api::AcademiesApi::Client,
      get_trust: Api::AcademiesApi::Client::Result.new(double, nil))

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)
    allow(fake_client).to receive(:get_establishment).with(establishment.urn).and_return(Api::AcademiesApi::Client::Result.new(establishment, nil))
    allow(fake_client).to receive(:get_establishment).with(another_establishment.urn).and_return(Api::AcademiesApi::Client::Result.new(another_establishment, nil))
    allow(fake_client).to receive(:get_establishment).with(yet_another_establishment.urn).and_return(Api::AcademiesApi::Client::Result.new(yet_another_establishment, nil))
    allow(fake_client).to receive(:get_establishments).with(any_args).and_return(Api::AcademiesApi::Client::Result.new([establishment, another_establishment, establishment, yet_another_establishment], nil))

    create(:local_authority, code: "909", name: "Cumbria County Council")
    create(:local_authority, code: "213", name: "Westminster City Council")
    create(:local_authority, code: "926", name: "Norfolk County Council")

    create(:conversion_project, urn: establishment.urn)
    create(:conversion_project, urn: another_establishment.urn)
    create(:conversion_project, urn: establishment.urn)
    create(:conversion_project, urn: yet_another_establishment.urn)

    result = described_class.new.call

    expect(result.count).to eql 3

    first_result = result.first

    expect(first_result.name).to eql "Cumbria County Council"
    expect(first_result.code).to eql "909"
    expect(first_result.conversion_count).to eql 2

    last_result = result.last

    expect(last_result.name).to eql "Westminster City Council"
    expect(last_result.code).to eql "213"
    expect(last_result.conversion_count).to eql 1
  end

  it "returns an empty array when there are no projects to source trusts" do
    expect(described_class.new.call).to eql []
  end
end
