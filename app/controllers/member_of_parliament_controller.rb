class MemberOfParliamentController < ApplicationController
  before_action :find_project
  rescue_from Api::MembersApi::Client::NotFoundError, with: :not_found_error
  rescue_from Api::MembersApi::Client::MultipleResultsError, with: :multiple_results_error
  rescue_from Api::MembersApi::Client::Error, with: :members_api_client_error

  def show
    @member_name = fetch_member_name
    @member_email = contact_details.email
    @parliamentary_office = contact_details
  end

  private def client
    @client ||= Api::MembersApi::Client.new
  end

  private def constituency
    @constituency ||= @project.establishment.parliamentary_constituency
  end

  private def member_id
    @member_id ||= fetch_member_id
  end

  private def member_contact_details
    @member_contact_details ||= fetch_member_contact_details
  end

  private def fetch_member_id
    result = client.member_id(constituency)
    raise result.error if result.error.present?
    result.object
  end

  private def fetch_member_name
    result = client.member_name(member_id)
    raise result.error if result.error.present?
    result
  end

  private def fetch_member_contact_details
    result = client.member_contact_details(member_id)
    raise result.error if result.error.present?
    result
  end

  private def contact_details
    member_contact_details.object
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def multiple_results_error
    render "multiple_results_error", status: 200
  end
end
