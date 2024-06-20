# Data Migration service
# This service is designed to be used once to update the category for all Contact::Establishment records
#
# Usage:
#
# `bin/rails runner "ContactEstablishmentDataMigration.new.migrate!"`
#
class ContactEstablishmentDataMigration
  def migrate!
    contacts = Contact::Establishment.all
    puts "#{contacts.count} Contact::Establishment records to update"

    contacts.each do |contact|
      contact.update!(category: "school_or_academy")
    end

    puts "All Contact::Establishment records updated"
  end
end
