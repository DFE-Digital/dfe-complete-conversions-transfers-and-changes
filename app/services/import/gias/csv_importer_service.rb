class Import::Gias::CsvImporterService
  require "csv"
  require "benchmark"

  ENCODING = "ISO-8859-1"

  def initialize
    raise NotImplementedError, "You need to instantiate this from a subclass to indicate which type of GIAS data you are importing"
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
    self.class::IMPORT_MAP.each_pair do |key, value|
      attributes[key.to_s] = row.field(value)
    end
    attributes
  end

  def required_column_headers_present?
    file = File.open(@path, encoding: ENCODING)
    headers = CSV.parse_line(file)
    return false if headers.nil?

    self.class::IMPORT_MAP.values.to_set.subset?(headers.to_set)
  end

  private def required_values_empty?(row)
    values = self.class::REQUIRED_VALUES.map do |value|
      row.field(self.class::IMPORT_MAP[value]).blank?
    end
    values.none?
  end
end
