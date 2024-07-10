module MembersApiHelpers
  def mock_successful_members_api_postcode_search_response(member_name:, member_contact_details:)
    member_name ||= build(:members_api_name)
    member_contact_details ||= build(:members_api_contact_details)
    member_details = Api::MembersApi::MemberDetails.new(member_name, member_contact_details)

    fake_result = Api::MembersApi::Client::Result.new(member_details, nil)
    test_client = Api::MembersApi::Client.new

    allow(test_client).to receive(:member_for_postcode).and_return(fake_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_members_api_multiple_postcodes_response
    fake_result = Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::MultipleResultsError.new)
    test_client = Api::MembersApi::Client.new

    allow(test_client).to receive(:member_for_postcode).and_return(fake_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_member_not_found_response
    test_client = Api::MembersApi::Client.new
    not_found_result = Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::NotFoundError.new)
    allow(test_client).to receive(:member_for_postcode).and_return(not_found_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_members_api_unavailable_response
    test_client = Api::MembersApi::Client.new
    error_result = Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::Error.new)
    allow(test_client).to receive(:member_for_postcode).and_return(error_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_nil_member_for_postcode_response
    test_client = Api::MembersApi::Client.new
    empty_result = Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::NotFoundError.new)
    allow(test_client).to receive(:member_for_postcode).and_return(empty_result)
    allow(Api::MembersApi::Client).to receive(:new).and_return(test_client)
  end
end
