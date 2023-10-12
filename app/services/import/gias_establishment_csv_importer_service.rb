class Import::GiasEstablishmentCsvImporterService
  require "csv"
  require "benchmark"

  ESTABLISHMENT_IMPORT_MAP = {
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

  ENCODING = "ISO-8859-1"

  def initialize(path)
    @path = path
    reset_import_stats
  end

  def import!
    reset_import_stats

    unless File.exist?(@path)
      @errors[:file] = "The source file at #{@path} could not be found."
      return import_result
    end

    unless required_columns_present?
      @errors[:headers] = "The source file at #{@path} does not contain all the required headers."
      return import_result
    end

    import_rows
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

  def establishment_csv_row_attributes(row)
    attributes = {}
    ESTABLISHMENT_IMPORT_MAP.each_pair do |key, value|
      attributes[key.to_s] = row.field(value)
    end
    attributes
  end

  def required_columns_present?
    file = File.open(@path, encoding: ENCODING)
    headers = CSV.parse_line(file)
    return false if headers.nil?

    ESTABLISHMENT_IMPORT_MAP.values.to_set.subset?(headers.to_set)
  end

  private def import_rows
    @time = Benchmark.realtime do
      CSV.foreach(@path, headers: true, encoding: ENCODING) do |row|
        urn = row.fetch("URN")
        establishment = Gias::Establishment.find_or_create_by(urn: urn)

        unless establishment
          @errors[:establishment][urn.to_sym] = "Could not find or create a record for urn: #{urn}"
          next
        end

        establishment_csv_attributes = establishment_csv_row_attributes(row)
        establishment_row_changes = changed_attributes(establishment_csv_attributes, establishment.attributes)

        if establishment_row_changes.any?
          unless establishment.update(establishment_csv_attributes)
            @errors[:establishment][urn.to_sym] = "Could not update establishment record for urn: #{urn}"
           next
          end
          @changed_rows[:establishment][establishment.urn] = establishment_row_changes
        end

        @total += 1
      end
    end

    import_result
  end

  private def reset_import_stats
    @total = 0
    @changed_rows = {
      establishment: {}
    }
    @current_establishment_records = Gias::Establishment.count
    @time = nil
    @errors = {
      establishment: {}
    }
  end

  private def import_result
    establishment_records_after_import = Gias::Establishment.count
    {
      total_csv_rows: @total,
      new_establishment_records: establishment_records_after_import - @current_establishment_records,
      changed_establishment_records: @changed_rows[:establishment].count - (establishment_records_after_import - @current_establishment_records),
      changes: @changed_rows,
      time: @time,
      errors: @errors
    }
  end
end
