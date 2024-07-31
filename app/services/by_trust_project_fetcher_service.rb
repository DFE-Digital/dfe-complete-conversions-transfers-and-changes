class ByTrustProjectFetcherService
  def initialize
    @all_projects_grouped_by_ukprn = []
    @all_projects_grouped_by_trust_reference_number = []

    @trusts = []
    @form_a_mat_trusts = []
  end

  def call
    @all_projects_grouped_by_ukprn = projects_grouped_by_ukprn
    @all_projects_grouped_by_trust_reference_number = projects_grouped_by_trust_reference_number

    if @all_projects_grouped_by_ukprn.any?
      @trusts = get_trusts(@all_projects_grouped_by_ukprn.keys)
    end

    if @all_projects_grouped_by_trust_reference_number.any?
      @form_a_mat_trusts = build_form_a_mat_trusts
    end

    sort_trust_objects_by_name(build_trust_objects)
  end

  private def all_trusts
    @trusts + @form_a_mat_trusts
  end

  private def projects_grouped_by_ukprn
    Project.active.not_form_a_mat.group_by(&:incoming_trust_ukprn)
  end

  private def projects_grouped_by_trust_reference_number
    Project.active.form_a_mat.group_by(&:new_trust_reference_number)
  end

  private def get_trusts(ukprns)
    client = Api::AcademiesApi::Client.new
    client.get_trusts(ukprns).object
  end

  private def build_form_a_mat_trusts
    the_projects = Project.active.where(incoming_trust_ukprn: nil).pluck(:new_trust_reference_number, :new_trust_name).to_h

    the_projects.map do |project|
      Api::AcademiesApi::Trust.new.from_hash({referenceNumber: project.first, name: project.last})
    end
  end

  private def build_trust_objects
    all_trusts.map do |trust|
      trust_projects = if trust.ukprn.present?
        @all_projects_grouped_by_ukprn.fetch(trust.ukprn.to_i)
      else
        @all_projects_grouped_by_trust_reference_number.fetch(trust.group_identifier)
      end

      OpenStruct.new(
        name: trust.name,
        ukprn: trust.ukprn,
        group_id: trust.group_identifier,
        conversion_count: trust_projects.count { |p| p.type == "Conversion::Project" },
        transfer_count: trust_projects.count { |p| p.type == "Transfer::Project" }
      )
    end
  end

  private def sort_trust_objects_by_name(trust_objects)
    trust_objects.sort_by { |trust_object| trust_object.name }
  end
end
