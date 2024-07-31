require "rails_helper"

RSpec.describe ByTrustProjectFetcherService do
  it "returns a sorted list of simple trust objects with project counts" do
    trust = build(
      :academies_api_trust,
      ukprn: 10066123,
      original_name: "THE GRAND UNION PARTNERSHIP",
      group_identifier: "TR03819"
    )
    another_trust = build(
      :academies_api_trust,
      ukprn: 10060639,
      original_name: "THE DIOCESE OF NORWICH EDUCATION AND ACADEMIES TRUST",
      group_identifier: "TR00663"
    )
    yet_another_trust = build(
      :academies_api_trust,
      ukprn: 10059745,
      original_name: "SPIRAL PARTNERSHIP TRUST",
      group_identifier: "TR00796"
    )

    trusts = [trust, another_trust, yet_another_trust]

    fake_client = double(Api::AcademiesApi::Client,
      get_trusts: Api::AcademiesApi::Client::Result.new(trusts, nil),
      get_establishment: Api::AcademiesApi::Client::Result.new(double, nil),
      get_trust: Api::AcademiesApi::Client::Result.new(trust, nil))

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)

    create(:conversion_project, incoming_trust_ukprn: yet_another_trust.ukprn)
    create(:conversion_project, incoming_trust_ukprn: another_trust.ukprn)
    create(:conversion_project, incoming_trust_ukprn: trust.ukprn)
    create(:conversion_project, incoming_trust_ukprn: yet_another_trust.ukprn)
    create(:transfer_project, incoming_trust_ukprn: trust.ukprn)
    create(:transfer_project, incoming_trust_ukprn: yet_another_trust.ukprn)

    result = described_class.new.call

    expect(result.count).to eql 3

    first_result = result.first

    expect(first_result.name).to eql "Spiral Partnership Trust"
    expect(first_result.ukprn).to eql 10059745
    expect(first_result.group_id).to eql "TR00796"
    expect(first_result.conversion_count).to eql 2
    expect(first_result.transfer_count).to eql 1

    last_result = result.last

    expect(last_result.name).to eql "The Grand Union Partnership"
    expect(last_result.ukprn).to eql 10066123
    expect(last_result.group_id).to eql "TR03819"
    expect(last_result.conversion_count).to eql 1
    expect(last_result.transfer_count).to eql 1
  end

  it "returns an empty array when there are no projects to source trusts" do
    expect(described_class.new.call).to eql []
  end

  it "returns the expected count of active conversion projects" do
    mock_all_academies_api_responses
    create(:conversion_project, :active)
    create(:conversion_project, :deleted)
    create(:conversion_project, :completed)
    create(:conversion_project, :dao_revoked)

    result = described_class.new.call.first

    expect(result.conversion_count).to be 1
  end

  it "returns the expected count of active transfer projects" do
    mock_all_academies_api_responses
    create(:transfer_project, :active)
    create(:transfer_project, :deleted)
    create(:transfer_project, :completed)
    create(:transfer_project, :dao_revoked)

    result = described_class.new.call.first

    expect(result.transfer_count).to be 1
  end

  describe "form a multi academy trust projects" do
    it "includes a form a MAT trust with the correct counts and details" do
      mock_successful_api_establishment_response(urn: 123456)

      create(:transfer_project, :active, incoming_trust_ukprn: nil, new_trust_reference_number: "TR12345", new_trust_name: "BRAND NEW TRUST")
      create(:conversion_project, :active, incoming_trust_ukprn: nil, new_trust_reference_number: "TR12345", new_trust_name: "BRAND NEW TRUST")
      create(:conversion_project, :active, incoming_trust_ukprn: nil, new_trust_reference_number: "TR54321", new_trust_name: "A DIFFERENT BRAND NEW TRUST")

      result = described_class.new.call

      expect(result.count).to be 2

      brand_new_trust = result.last
      a_different_brand_new_trust = result.first

      expect(a_different_brand_new_trust.name).to eql "A Different Brand New Trust"
      expect(a_different_brand_new_trust.group_id).to eql "TR54321"
      expect(a_different_brand_new_trust.conversion_count).to be 1
      expect(a_different_brand_new_trust.transfer_count).to be 0


      expect(brand_new_trust.name).to eql "Brand New Trust"
      expect(brand_new_trust.group_id).to eql "TR12345"
      expect(brand_new_trust.conversion_count).to be 1
      expect(brand_new_trust.transfer_count).to be 1
    end
  end
end
