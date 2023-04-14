class EstablishmentsFetcher
  def call(projects)
    return unless projects&.any?

    urns = projects.map(&:urn)
    establishments = Api::AcademiesApi::Client.new.get_establishments(urns).object

    projects.each do |project|
      project.establishment = establishments.find { |establishment| establishment.urn == project.urn.to_s }
    end
  end
end
