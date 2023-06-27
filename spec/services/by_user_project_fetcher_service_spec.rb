require "rails_helper"

RSpec.describe ByUserProjectFetcherService do
  it "returns a sorted list of simple user objects with projects" do
    mock_successful_api_response_to_create_any_project

    user = create(:user, first_name: "A", last_name: "User", email: "a.user@education.gov.uk")
    another_user = create(:user, first_name: "B", last_name: "User", email: "b.user@education.gov.uk")
    yet_another_user = create(:user, first_name: "C", last_name: "User", email: "c.user@education.gov.uk")

    create(:conversion_project, urn: 121813, assigned_to: user)
    create(:conversion_project, urn: 121102, assigned_to: user)
    create(:conversion_project, urn: 117574, assigned_to: another_user)
    create(:conversion_project, urn: 121583, assigned_to: nil)
    create(:conversion_project, urn: 121583, assigned_to: yet_another_user)

    result = described_class.new.call

    expect(result.count).to eql 3

    first_result = result.first

    expect(first_result.name).to eql "A User"
    expect(first_result.conversion_count).to eql 2

    last_result = result.last

    expect(last_result.name).to eql "C User"
    expect(last_result.conversion_count).to eql 1
  end

  it "returns an empty array when there are no projects to source trusts" do
    expect(described_class.new.call).to eql []
  end
end
