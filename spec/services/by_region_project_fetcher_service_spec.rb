require "rails_helper"

RSpec.describe ByRegionProjectFetcherService do
  it "returns a sorted list of simple view objects with project counts" do
    mock_successful_api_response_to_create_any_project

    create(:conversion_project, region: "south_west")
    create(:conversion_project, region: "london")
    create(:conversion_project, region: "south_west")
    create(:conversion_project, region: "north_west")

    result = described_class.new.conversion_counts

    expect(result.count).to eql 3

    first_result = result.first

    expect(first_result.name).to eql "london"
    expect(first_result.conversion_count).to eql 1

    last_result = result.last

    expect(last_result.name).to eql "south_west"
    expect(last_result.conversion_count).to eql 2
  end

  it "returns an empty array when there are no projects to source trusts" do
    expect(described_class.new.conversion_counts).to eql []
  end
end
