class EstablishmentsFetcherService
  def initialize(projects)
    @establishments = []
    @projects = projects
  end

  def call!
    return unless @projects&.any?
    raise ArgumentError.new("You must pass in the result of an ActiveRecord query (ActiveRecord::Relation)") unless @projects.is_a?(ActiveRecord::Relation)

    @projects.in_batches(of: 20) do |batch_of_projects|
      urns = batch_of_projects.pluck(:urn)
      @establishments += Api::AcademiesApi::Client.new.get_establishments(urns).object
    end

    @projects.each do |project|
      project.establishment = @establishments.find { |establishment| establishment.urn == project.urn.to_s }
    end
  end
end
