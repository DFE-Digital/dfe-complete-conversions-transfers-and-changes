require "csv"

class Import::AcademyOpenDateImporterService
  def initialize(path)
    @path = path
  end

  def import!
    result = []

    CSV.foreach(@path, headers: true, header_converters: :symbol) do |row|
      previous_urn = row.field(:previous_urn)
      academy_urn = row.field(:academy_urn)
      date = Date.parse(row.field(:date))

      project = project(previous_urn, academy_urn)

      if project
        success = update_project(project, date)
        result << {previous_urn: previous_urn, academy_urn: academy_urn, project_id: project.id, success: success}
      else
        result << {previous_urn: previous_urn, academy_urn: academy_urn, project_id: nil, success: false}
      end
    end

    result
  end

  private def update_project(project, date)
    project.tasks_data.update!(confirm_date_academy_opened_date_opened: date)
  end

  private def project(previous_urn, academy_urn)
    Project.find_by(urn: previous_urn, academy_urn: academy_urn)
  end
end
