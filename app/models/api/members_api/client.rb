class Api::MembersApi::Client
  class Error < StandardError; end

  class MultipleResultsError < StandardError; end

  class NotFoundError < StandardError; end

  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  def member_for_postcode(postcode)
    response = postcode_search(postcode)

    case response.status
    when 200
      result = JSON.parse(response.body)["items"]

      return Result.new(nil, MultipleResultsError.new(I18n.t("members_api.errors.multiple", search_term: postcode))) if result.count > 1
      return Result.new(nil, NotFoundError.new(I18n.t("members_api.errors.postcode_not_found", postcode: postcode))) if result.count == 0

      build_postcode_result(result)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("members_api.errors.postcode_not_found", postcode: postcode)))
    else
      Result.new(nil, Error.new(I18n.t("members_api.errors.other", status: response.status, search_term: postcode)))
    end
  end

  private def build_postcode_result(result)
    member_name = Api::MembersApi::MemberName.new.from_hash(result[0]["value"])
    contact_details = member_contact_details(member_name.id).object

    Result.new(Api::MembersApi::MemberDetails.new(member_name, contact_details), nil)
  end

  def member_contact_details(member_id)
    response = contact_details_search(member_id)

    case response.status
    when 200
      contact_details = JSON.parse(response.body)["value"]
      parliamentary_office = contact_details.find { |c| c["typeId"] == 1 }
      Result.new(Api::MembersApi::MemberContactDetails.new.from_hash(parliamentary_office), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("members_api.errors.member_not_found", member_id: member_id)))
    else
      Result.new(nil, Error.new(I18n.t("members_api.errors.other")))
    end
  end

  private def postcode_search(search_term)
    @connection.get("/api/Members/Search", {Location: search_term, House: 1, IsCurrentMember: true})
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def contact_details_search(member_id)
    @connection.get("/api/Members/#{member_id}/Contact")
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def default_connection
    Faraday.new(
      url: ENV["MEMBERS_API_HOST"],
      request: {
        params_encoder: Faraday::FlatParamsEncoder
      },
      headers: {
        "Content-Type": "application/json"
      }
    )
  end

  class Result
    attr_reader :object, :error

    def initialize(object, error)
      @object = object
      @error = error
    end
  end
end
