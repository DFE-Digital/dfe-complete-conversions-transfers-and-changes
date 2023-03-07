require "csv"
class InvalidEntryError < StandardError
end

class UserImporter
  def call(csv_path)
    @csv_path = csv_path
    upsert_users
  end

  private def upsert_users
    User.transaction do
      CSV.foreach(@csv_path, headers: true, header_converters: :symbol) do |row|
        user = User.find_or_create_by(email: row[:email])
        user.assign_attributes(row)
        unless user.save
          raise InvalidEntryError
        end
      end
    end
  end
end
