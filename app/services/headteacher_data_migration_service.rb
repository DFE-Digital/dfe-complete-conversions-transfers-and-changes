# Data migration service
#
# This data migration is designed to be run in production and then deleted
#
# For every project it finds all associated `Contact::Establishment` and copies
# them to `Contact::Project` making them selectable as key contacts and
# editable.
#
# It does not delete any records.
#
# To run:
#
# bin/rails runner HeadteacherDataMigrationService.new.migrate!
#
class HeadteacherDataMigrationService
  def migrate!
    Project.all.each do |project|
      contacts_to_copy = Contact::Establishment.where(establishment_urn: project.urn)

      if contacts_to_copy.present?
        contacts_to_copy.each do |contact|
          puts "Copying contact #{contact.id}"
          Contact::Project.create(
            name: contact.name,
            title: contact.title,
            email: contact.email,
            phone: contact.phone,
            organisation_name: project.establishment.name,
            category: :school_or_academy,
            project: project
          )
        end
        puts "Establishment contacts for project #{project.id} copied"
      else
        puts "No establishment contacts for project #{project.id}"
      end
    end
  end
end
