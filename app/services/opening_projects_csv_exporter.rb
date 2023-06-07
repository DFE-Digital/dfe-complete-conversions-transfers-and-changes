require "csv"

class OpeningProjectsCsvExporter
  def initialize(projects)
    @projects = projects
  end

  def call
    @csv = CSV.generate(headers: true) do |csv|
      csv << headers
      @projects.each do |project|
        csv << row(project)
      end
    end
  end

  private def headers
    ["School URN", "DfE number", "School name"]
  end

  private def row(project)
    [project.urn, project.establishment.dfe_number, project.establishment.name]
  end
end
