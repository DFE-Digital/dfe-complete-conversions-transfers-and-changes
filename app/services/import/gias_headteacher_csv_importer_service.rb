class Import::GiasHeadteacherCsvImporterService < Import::GiasCsvImporterService
  require "csv"

  IMPORT_MAP = {
    title: "HeadPreferredJobTitle",
    first_name: "HeadFirstName",
    last_name: "HeadLastName",
    email: "HeadEmail",
    establishment_urn: "URN",
    organisation_name: "EstablishmentName"
  }.freeze

  REQUIRED_VALUES = [
    :first_name,
    :last_name,
    :email,
    :establishment_urn
  ].freeze

  def initialize(path)
    @path = path
    initialize_import_result
  end

  def import!
    initialize_import_result
    Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Starting import from file #{@path}"

    unless File.exist?(@path)
      Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Source file #{@path} could not be found."
      return import_result
    end

    unless required_column_headers_present?
      Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Source file #{@path} does not contain the required headers."
      return import_result
    end

    start_time = Time.now

    CSV.foreach(@path, headers: true, encoding: ENCODING) do |row|
      next unless import_row(row)
    end

    @time_taken = Time.now - start_time

    Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Finished import from file #{@path}"
    import_result
  end

  def csv_row_attributes(row)
    attributes = {}
    IMPORT_MAP.each_pair do |key, value|
      case key.to_s
      when "first_name"
        next
      when "last_name"
        attributes["name"] = "#{row.field("HeadFirstName")} #{row.field("HeadLastName")}"
      when "title"
        attributes["title"] = row.field("HeadPreferredJobTitle").blank? ? "Headteacher" : row.field("HeadPreferredJobTitle")
      else
        attributes[key.to_s] = row.field(value)
      end
    end
    attributes["category"] = "school_or_academy"
    attributes
  end

  def import_row(row)
    @csv_rows += 1
    urn = row.field("URN")
    establishment = Gias::Establishment.find_by_urn(urn)

    unless establishment
      Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Could not find an establishment with the URN: #{urn} - skipping row."
      @skipped_csv_rows += 1
      return false
    end

    unless required_values_empty?(row)
      Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] The required fields are not present in the row for the establishment with URN: #{urn} - skipping row."
      @skipped_csv_rows += 1
      return false
    end

    contact = Contact::Establishment.find_or_create_by(establishment_urn: urn)

    unless contact
      Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Could not find or create the contact for establishment with URN: #{urn} - skipping row."
      @skipped_csv_rows += 1
      return false
    end

    @csv_rows_with_contact += 1

    Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Contact found or created for establishment with URN: #{urn}."

    contact_csv_attributes = csv_row_attributes(row)
    contact_row_changes = changed_attributes(contact_csv_attributes, contact.attributes)

    if contact_row_changes.any?
      if contact.update(contact_csv_attributes)
        Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Contact updated for establishment with URN: #{urn}."
        @changed_rows[contact.establishment_urn.to_s] = contact_row_changes
      else
        Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] Could not update contact for establishment with URN: #{urn}."
        return false
      end
    else
      Rails.logger.info "[IMPORT][GIAS][HEADTEACHER] No changes to contact for establishment with URN: #{urn}."
      @no_changes += 1
    end

    true
  end

  private def initialize_import_result
    @csv_rows = 0
    @csv_rows_with_contact = 0
    @skipped_csv_rows = 0
    @no_changes = 0
    @changed_rows = {}
    @current_records = Contact::Establishment.count
    @time_taken = nil
  end

  private def import_result
    contact_records_after_import = Contact::Establishment.count
    {
      file: @path,
      total_csv_rows: @csv_rows,
      skipped_csv_rows: @skipped_csv_rows,
      total_csv_rows_with_a_contact: @csv_rows_with_contact,
      new_contacts: contact_records_after_import - @current_records,
      contacts_changed: @changed_rows.count - (contact_records_after_import - @current_records),
      contacts_not_changed: @no_changes,
      time_taken: @time_taken,
      changes: @changed_rows
    }
  end
end
