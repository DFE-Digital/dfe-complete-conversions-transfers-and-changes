class Export::RiskProtectionArrangementCsvExportService
  require "csv"

  COLUMN_HEADERS = %i[
    school_urn
    school_name
    academy_urn
    academy_name
    incoming_trust_identifier
    incoming_trust_companies_house_number
    incoming_trust_name
    conversion_date
    all_conditions_met
    risk_protection_arrangement
    assigned_to_name
    assigned_to_email
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
