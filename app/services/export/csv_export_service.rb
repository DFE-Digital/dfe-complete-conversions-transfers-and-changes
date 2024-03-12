class Export::CsvExportService
  require "csv"

  def initialize
    raise NotImplementedError, "You need to instantiate this from a subclass to indicate which type of CSV you are exporting"
  end

  def call
    @csv = CSV.generate("\uFEFF", headers: true, encoding: "UTF-8") do |csv|
      csv << headers
      if @projects.any?
        @projects.each do |project|
          Rails.logger.debug("--> Creating csv row for project #{project.id}")
          csv << row(project)
        end
      end
    end
  end

  private def headers
    self.class::COLUMN_HEADERS.map do |column|
      I18n.t("export.csv.project.headers.#{column}")
    end
  end

  private def row(project)
    presenter = Export::Csv::ProjectPresenter.new(project)

    self.class::COLUMN_HEADERS.map do |column|
      presenter.public_send(column)
    end
  end
end
