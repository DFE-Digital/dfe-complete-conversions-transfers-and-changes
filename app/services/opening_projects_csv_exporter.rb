class OpeningProjectsCsvExporter
  require "csv"

  def initialize(projects)
    @projects = projects

    raise ArgumentError.new("You must provide at least one project") if @projects.count.zero?
  end

  def call
    @csv = CSV.generate(headers: true) do |csv|
      csv << headers
      @projects.each do |project|
        csv << row(project).values
      end
    end
  end

  private def headers
    example_row = row(@projects.first)
    example_row.keys.map do |column|
      I18n.t("opening_projects_csv_export.headers.#{column}")
    end
  end

  private def row(project)
    {
      school_urn: project.urn,
      dfe_number: project.establishment.dfe_number,
      school_name: project.establishment.name
    }
  end
end
