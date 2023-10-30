class Import::GiasEstablishmentCsvImporterService
  require "csv"
  require "benchmark"

  IMPORT_MAP = {
    urn: "URN",
    local_authority_code: "LA (code)",
    local_authority_name: "LA (name)",
    establishment_number: "EstablishmentNumber",
    name: "EstablishmentName",
    phase_code: "PhaseOfEducation (code)",
    phase_name: "PhaseOfEducation (name)",
    age_range_lower: "StatutoryLowAge",
    age_range_upper: "StatutoryHighAge",
    diocese_code: "Diocese (code)",
    diocese_name: "Diocese (name)",
    ukprn: "UKPRN",
    type_code: "TypeOfEstablishment (code)",
    type_name: "TypeOfEstablishment (name)",
    address_street: "Street",
    address_locality: "Locality",
    address_additional: "Address3",
    address_town: "Town",
    address_county: "County (name)",
    address_postcode: "Postcode",
    url: "SchoolWebsite",
    region_code: "GOR (code)",
    region_name: "GOR (name)",
    parliamentary_constituency_code: "ParliamentaryConstituency (code)",
    parliamentary_constituency_name: "ParliamentaryConstituency (name)"
  }.freeze

  REQUIRED_VALUES = [
    :urn
  ].freeze

  ENCODING = "ISO-8859-1"

  def initialize(path)
    @path = path
    initialize_import_result
  end

  def import!
    initialize_import_result
    Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Starting import from file #{@path}"

    unless File.exist?(@path)
      Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Source file #{@path} could not be found."
      return import_result
    end

    unless required_column_headers_present?
      Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Source file #{@path} does not contain the required headers."
      return import_result
    end

    start_time = Time.now

    CSV.foreach(@path, headers: true, encoding: ENCODING) do |row|
      next unless import_row(row)
    end

    @time_taken = Time.now - start_time

    Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Finished import from file #{@path}"
    import_result
  end

  def import_row(row)
    @csv_rows += 1
    urn = row.field("URN")
    establishment = Gias::Establishment.find_or_create_by(urn: urn)

    unless establishment
      Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Could not find or create an establishment with the URN: #{urn} - skipping row."
      @skipped_csv_rows += 1
      return false
    end

    unless required_values_empty?(row)
      Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] The required values are not present in row #{@csv_rows} - skipping row."
      @skipped_csv_rows += 1
      return false
    end

    Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Establishment found or created with URN: #{urn}."

    csv_attributes = csv_row_attributes(row)
    row_changes = changed_attributes(csv_attributes, establishment.attributes)

    if row_changes.any?
      if establishment.update(csv_attributes)
        Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Establishment with URN: #{urn} updated."
        @changed_rows[establishment.urn.to_s] = row_changes
      else
        Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] Could not update establishment with URN: #{urn}."
        return false
      end
    else
      Rails.logger.info "[IMPORT][GIAS][ESTABLISHMENT] No changes to establishment with URN: #{urn}."
      @no_changes += 1
    end

    true
  end

  def changed_attributes(csv_attributes, model_attributes)
    model_attribute_strings = model_attributes.transform_values(&:to_s)
    csv_attribute_strings = csv_attributes.transform_values(&:to_s)

    result = {}
    csv_attribute_strings.each_pair do |key, value|
      unless model_attribute_strings[key] == value
        result[key] = {previous_value: model_attribute_strings[key], new_value: value}
      end
    end
    result
  end

  def csv_row_attributes(row)
    attributes = {}
    IMPORT_MAP.each_pair do |key, value|
      attributes[key.to_s] = row.field(value)
    end
    attributes
  end

  def required_column_headers_present?
    file = File.open(@path, encoding: ENCODING)
    headers = CSV.parse_line(file)
    return false if headers.nil?

    IMPORT_MAP.values.to_set.subset?(headers.to_set)
  end

  private def required_values_empty?(row)
    values = REQUIRED_VALUES.map do |value|
      row.field(IMPORT_MAP[value]).blank?
    end
    values.none?
  end

  private def initialize_import_result
    @csv_rows = 0
    @skipped_csv_rows = 0
    @no_changes = 0
    @changed_rows = {}
    @current_records = Gias::Establishment.count
    @time_taken = nil
  end

  private def import_result
    records_after_import = Gias::Establishment.count
    {
      file: @path,
      total_csv_rows: @csv_rows,
      skipped_csv_rows: @skipped_csv_rows,
      new: records_after_import - @current_records,
      changed: @changed_rows.count - (records_after_import - @current_records),
      no_changes: @no_changes,
      time_taken: @time_taken,
      changes: @changed_rows
    }
  end
end
