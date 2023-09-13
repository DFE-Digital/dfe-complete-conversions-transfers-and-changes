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

  ENCODING = "ISO-8859-1"

  def initialize(path)
    @path = path
  end

  def import!
    total_records = 0
    changed_records = 0
    skipped_records = 0

    time = Benchmark.realtime do
      CSV.foreach(@path, headers: true, encoding: ENCODING) do |row|
        establishment = Gias::Establishment.find_or_create_by!(urn: row.fetch("URN"))
        csv_attributes = csv_row_attributes(row)

        if values_updated?(csv_attributes, establishment.attributes)
          establishment.update!(csv_attributes)
          changed_records += 1
        else
          skipped_records += 1
        end

        total_records += 1
      end
    end

    print "# records updated: #{changed_records}\n# records skipped: #{skipped_records}\n\nTotal # records: #{total_records}\n\nTime taken: #{time}"
    true
  end

  def values_updated?(csv_attributes, model_attributes)
    model_attribute_strings = model_attributes.transform_values(&:to_s)
    csv_attribute_strings = csv_attributes.transform_values(&:to_s)

    result = false
    csv_attribute_strings.each_pair do |key, value|
      result = true unless model_attribute_strings[key] == value
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

  def required_columns_present?
    file = File.open(@path, encoding: ENCODING)
    headers = CSV.parse_line(file)
    return false if headers.nil?

    IMPORT_MAP.values.to_set.subset?(headers.to_set)
  end
end
