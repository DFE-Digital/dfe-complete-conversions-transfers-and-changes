require "csv"

class InvalidEntryError < StandardError
end

class MissingLocalAuthorityError < StandardError
end

class Import::DirectorOfChildServicesCsvImporterService
  def call(csv_path)
    sanitized_csv(csv_path).each do |row|
      Contact::DirectorOfChildServices.transaction do
        local_authority = LocalAuthority.find_by(code: row[:la])
        if local_authority
          dcs = Contact::DirectorOfChildServices.find_or_create_by(local_authority_id: local_authority.id)
          dcs.name = row[:name]
          dcs.title = row[:title]
          dcs.email = row[:email]
          dcs.phone = row[:phone]
          unless dcs.save
            puts "Unable to save Contact::DirectorOfChildServices for LocalAuthority code #{row[:la]}"
            raise InvalidEntryError.new(dcs.errors)
          end
        else
          raise MissingLocalAuthorityError.new("Local Authority code #{row[:la]} does not exist")
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
