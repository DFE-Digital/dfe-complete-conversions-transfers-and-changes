class Api::MembersApi::Client
  class Error < StandardError; end

  class MultipleResultsError < StandardError; end

  class NotFoundError < StandardError; end

  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  def constituency(search_term)
    response = constituency_search(search_term)

    case response.status
    when 200
      body = JSON.parse(response.body)
      Result.new(body, nil)
    else
      Result.new(nil, Error.new(I18n.t("members_api.errors.other", search_term: search_term, status: response.status)))
    end
  end

  def member_for_constituency(constituency)
    member = member_id(constituency)

    return Result.new(nil, member.error) if member.error.present?

    member_id = member.object
    member_name = member_name(member_id).object
    contact_details = member_contact_details(member_id).object.find { |details| details.type_id == 1 }

    Result.new(Api::MembersApi::MemberDetails.new(member_name, contact_details), nil)
  rescue NoMethodError
    Result.new(nil, Error.new(I18n.t("members_api.errors.contact_details_not_found", member_id: member_id)))
  end

  def member_id(search_term)
    constituency_data = constituency(search_term)
    if constituency_data.error.present?
      return Result.new(nil, constituency_data.error)
    end

    if constituency_data.object["items"].count == 0
      Result.new(nil, NotFoundError.new(NotFoundError.new(I18n.t("members_api.errors.search_term_not_found", constituency: search_term))))
    elsif constituency_data.object["items"].count > 1
      Result.new(nil, MultipleResultsError.new(I18n.t("members_api.errors.multiple", search_term: search_term)))
    else
      Result.new(member_id_from_constituency(constituency_data), nil)
    end
  end

  def member_name(member_id)
    response = member(member_id)

    case response.status
    when 200
      result = JSON.parse(response.body)["value"]
      Result.new(Api::MembersApi::MemberName.new.from_hash(result), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("members_api.errors.member_not_found", member_id: member_id)))
    else
      Result.new(nil, Error.new(I18n.t("members_api.errors.other")))
    end
  end

  def member_contact_details(member_id)
    response = member_contact(member_id)

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

  private def constituency_search(search_term)
    @connection.get("/api/Location/Constituency/Search", {searchText: search_term})
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def member_id_from_constituency(constituency_data)
    constituency = constituency_data.object["items"][0]["value"]
    constituency.dig("currentRepresentation", "member", "value", "id")
  end

  private def member(member_id)
    @connection.get("/api/Members/#{member_id}")
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def member_contact(member_id)
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
