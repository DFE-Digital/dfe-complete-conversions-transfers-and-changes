class Export::RiskProtectionArrangementCsvExportService
  require "csv"

  COLUMN_HEADERS = %i[
    school_urn
    school_name
    academy_urn
    academy_name
    trust_identifier
    trust_companies_house_number
    trust_name
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
      I18n.t("export.risk_protection_arrangement.csv.headers.#{column}")
    end
  end

  private def row(project)
    presenter = ConversionProjectCsvPresenter.new(project)

    COLUMN_HEADERS.map do |column|
      presenter.public_send(column)
    end
  end

  class ConversionProjectCsvPresenter
    def initialize(project)
      @project = project
    end

    def school_urn
      @project.urn.to_s
    end

    def school_name
      @project.establishment.name
    end

    def academy_urn
      if @project.academy_urn.nil?
        return I18n.t("export.risk_protection_arrangement.csv.values.unconfirmed")
      end

      @project.academy_urn.to_s
    end

    def academy_name
      if @project.academy_urn.nil? || @project.academy.name.nil?
        return I18n.t("export.risk_protection_arrangement.csv.values.unconfirmed")
      end

      @project.academy.name
    end

    def trust_identifier
      @project.incoming_trust.group_identifier.to_s
    end

    def trust_companies_house_number
      @project.incoming_trust.companies_house_number.to_s
    end

    def trust_name
      @project.incoming_trust.name
    end

    def conversion_date
      @project.conversion_date.to_fs(:csv)
    end

    def all_conditions_met
      if @project.tasks_data.conditions_met_confirm_all_conditions_met.nil?
        return I18n.t("export.risk_protection_arrangement.csv.values.no")
      end

      I18n.t("export.risk_protection_arrangement.csv.values.yes")
    end

    def risk_protection_arrangement
      if @project.tasks_data.risk_protection_arrangement_option.nil?
        return I18n.t("export.risk_protection_arrangement.csv.values.unconfirmed")
      end

      I18n.t("export.risk_protection_arrangement.csv.values.#{@project.tasks_data.risk_protection_arrangement_option}")
    end

    def assigned_to_name
      @project.assigned_to.full_name
    end

    def assigned_to_email
      @project.assigned_to.email
    end
  end
end
