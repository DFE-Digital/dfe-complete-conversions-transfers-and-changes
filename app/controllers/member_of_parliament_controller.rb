class MemberOfParliamentController < ApplicationController
  before_action :find_project
  rescue_from Api::MembersApi::Client::NotFoundError, with: :not_found_error
  rescue_from Api::MembersApi::Client::MultipleResultsError, with: :multiple_results_error
  rescue_from Api::MembersApi::Client::Error, with: :members_api_client_error

  def show
    @member_of_parliament = member_of_parliament
    @parliamentary_office = parliamentary_office
  end

  private def postcode
    @project.establishment.address_postcode
  end

  private def member_of_parliament
    result = client.member_for_postcode(postcode)
    raise result.error if result.error.present?

    result.object
  end

  private def parliamentary_office
    @member_of_parliament.address.to_h.map { |_k, value| value }
  end

  private def client
    @client ||= Api::MembersApi::Client.new
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def multiple_results_error
    render "multiple_results_error", status: 200
  end
end
