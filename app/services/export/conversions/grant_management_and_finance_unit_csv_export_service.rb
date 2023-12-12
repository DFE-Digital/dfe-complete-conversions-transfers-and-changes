class Export::Conversions::GrantManagementAndFinanceUnitCsvExportService
  require "csv"

  COLUMN_HEADERS = %i[
    school_urn
    school_name
    school_type
    school_phase
    local_authority_name
    region
    incoming_trust_name
    incoming_trust_identifier
    advisory_board_date
    conversion_date
    academy_order_type
    two_requires_improvement
    sponsored_grant_type
    assigned_to_name
    assigned_to_email
    link_to_project
  ]

  def initialize(projects)
    @projects = projects
  end

  def call
    @csv = CSV.generate("\uFEFF", headers: true, encoding: "UTF-8") do |csv|
      csv << headers
      if @projects.any?
        @projects.each do |project|
          csv << row(project)
        end
      end
    end
  end

  private def headers
    COLUMN_HEADERS.map do |column|
      I18n.t("export.csv.project.headers.#{column}")
    end
  end

  private def row(project)
    presenter = Export::Csv::ProjectPresenter.new(project)

    COLUMN_HEADERS.map do |column|
      presenter.public_send(column)
    end
  end
end
