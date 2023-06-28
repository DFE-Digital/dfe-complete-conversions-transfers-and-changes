class EstablishmentsFetcher
  def initialize
    @establishments = []
  end

  def call(projects)
    return unless projects&.any?
    raise ArgumentError unless projects.is_a?(ActiveRecord::Relation)

    projects.in_batches(of: 20) do |batch_of_projects|
      urns = batch_of_projects.pluck(:urn)
      @establishments += Api::AcademiesApi::Client.new.get_establishments(urns).object
    end

    projects.each do |project|
      project.establishment = @establishments.find { |establishment| establishment.urn == project.urn.to_s }
    end
  end
end
