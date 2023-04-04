class ProjectRegionMigrator
  def initialize(project)
    @project = project
  end

  def migrate_up!
    if @project.region.nil?
      establishment = @project.establishment
      @project.region = establishment.region_code
      @project.save(validate: false)
    end
  end
end
