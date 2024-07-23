require "csv"

class InvalidEntryError < StandardError; end

class Import::MemberOfParliamentCsvImporterService
  def call(csv_path)
    CSV.foreach(csv_path, headers: true) do |row|
      next unless row["value.email"].present?

      constituency = row["value.latestHouseMembership.membershipFrom"].strip
      member = Contact::Parliament.find_or_create_by(parliamentary_constituency: constituency)
      member.name = row["value.nameFullTitle"].strip
      member.email = row["value.email"].strip
      member.title = I18n.t("members_api.member.title", constituency: constituency.titleize)
      unless member.save
        puts "Unable to save Member of Parliament for constituency #{constituency}"
        raise InvalidEntryError
      end
    end
  end
end
