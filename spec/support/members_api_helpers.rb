module MembersApiHelpers
  def mock_successful_members_api_responses(member_name:, member_contact_details:)
    mock_successful_constituency_search_response
    mock_successful_member_id_response
    mock_successful_member_name_response(member_name: member_name)
    mock_successful_member_contact_details_response(member_contact_details: member_contact_details)
  end

  def mock_successful_constituency_search_response
    fake_body = {"items" => [{"value" => {"name" => "St Albans", "id" => 12345}}]}
    fake_result = Api::MembersApi::Client::Result.new(fake_body, nil)
    test_client = Api::MembersApi::Client.new

    allow(test_client).to receive(:constituency).and_return(fake_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_successful_member_id_response
    test_client = Api::MembersApi::Client.new
    fake_result = Api::MembersApi::Client::Result.new("12345", nil)

    allow(test_client).to receive(:member_id).and_return(fake_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_successful_member_name_response(member_name:)
    member_name = build(:members_api_name) if member_name.nil?

    fake_result = Api::MembersApi::Client::Result.new(member_name, nil)
    test_client = Api::MembersApi::Client.new

    allow(test_client).to receive(:member_name).and_return(fake_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_successful_member_contact_details_response(member_contact_details:)
    member_contact_details = [build(:members_api_contact_details)] if member_contact_details.nil?

    fake_result = Api::MembersApi::Client::Result.new(member_contact_details, nil)
    test_client = Api::MembersApi::Client.new

    allow(test_client).to receive(:member_contact_details).and_return(fake_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_successful_memeber_details
    address = OpenStruct.new(
      line1: "House of Commons",
      line2: "London",
      line3: "",
      postcode: "SW1A 0AA"
    )

    member_details = double(
      Api::MembersApi::MemberDetails,
      name: "Member Parliment",
      email: "member.parliment@parliment.uk",
      address: address
    )
    members_client = double(Api::MembersApi::Client, member_for_constituency: member_details)
    allow(Api::MembersApi::Client).to receive(:new).and_return(members_client)
  end

  def mock_members_api_multiple_constituencies_response
    fake_body = {"items" => [
      {"value" => {"name" => "St Albans", "id" => 12345}},
      {"value" => {"name" => "Lewisham West and Penge", "id" => 67890}}
    ]}

    fake_result = Api::MembersApi::Client::Result.new(fake_body, nil)
    test_client = Api::MembersApi::Client.new

    allow(test_client).to receive(:constituency).and_return(fake_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_member_not_found_response
    test_client = Api::MembersApi::Client.new
    not_found_result = Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::NotFoundError)
    allow(test_client).to receive(:member_name).and_return(not_found_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_contact_details_not_found_response
    test_client = Api::MembersApi::Client.new
    not_found_result = Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::NotFoundError)

    allow(test_client).to receive(:member_contact_details).and_return(not_found_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_members_api_unavailable_response
    test_client = Api::MembersApi::Client.new
    error_result = Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::Error)
    allow(test_client).to receive(:constituency).and_return(error_result)
    allow(test_client).to receive(:member_name).and_return(error_result)
    allow(test_client).to receive(:member_contact_details).and_return(error_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end
end
