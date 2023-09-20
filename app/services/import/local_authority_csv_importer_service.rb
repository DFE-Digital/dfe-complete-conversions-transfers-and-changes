require "csv"

class InvalidEntryError < StandardError
end

class Import::LocalAuthorityCsvImporterService
  def call(csv_path)
    sanitized_csv(csv_path).each do |row|
      LocalAuthority.transaction do
        local_authority = LocalAuthority.find_or_create_by(code: row[:la])
        local_authority.name = row[:local_authority_name]
        local_authority.address_1 = row[:dcs_address_1]
        local_authority.address_2 = row[:dcs_address_2]
        local_authority.address_3 = row[:dcs_address_3]
        local_authority.address_town = row[:dcs_town]
        local_authority.address_county = row[:dcs_county]
        local_authority.address_postcode = row[:dcs_postcode]
        unless local_authority.save
          puts "Unable to save local authority for code #{row[:la]}"
          raise InvalidEntryError
        end
      end
    end
  end

  def sanitized_csv(csv_path)
    sanitized_rows = []
    CSV.foreach(csv_path, headers: true, header_converters: :symbol) do |row|
      sanitized_row = row.map do |key, value|
        value = (value.blank? || value == "0") ? nil : value
        [key, value]
      end.to_h
      sanitized_rows << sanitized_row
    end
    sanitized_rows
  end
end
