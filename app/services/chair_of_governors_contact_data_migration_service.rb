#
# Data migration service
#
# Run with:
#
# bin/rails runner ChairOfGovernorsContactDataMigrationService.new.migrate!
#
# Copies the existing `chair_of_governors_contact` to the new `KeyContacts.chair_of_governors`.
#
# Delete once run in production
#
class ChairOfGovernorsContactDataMigrationService
  def migrate!
    Conversion::Project.all.each do |project|
      if project.chair_of_governors_contact.present?
        puts "Found chair of governor for project id #{project.id}"

        key_contacts = KeyContacts.find_or_create_by(project: project)

        key_contacts.update!(chair_of_governors: project.chair_of_governors_contact)

        puts "Updated chair of governor for project"
        puts "----"
      end
    end
  end
end
