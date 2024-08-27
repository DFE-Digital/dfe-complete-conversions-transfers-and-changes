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
      main_contact_id = project.main_contact_id
      establishment_main_contact_id = project.establishment_main_contact_id

      if contacts_to_copy.present?
        contacts_to_copy.each do |contact|
          next if Contact::Project.find_by(email: contact.email)

          puts "Copying contact #{contact.id}"
          organisation_name = contact.establishment&.name
          new_contact = Contact::Project.create(
            name: contact.name,
            title: contact.title,
            email: contact.email,
            phone: contact.phone,
            organisation_name: organisation_name,
            category: :school_or_academy,
            project: project
          )
          if main_contact_id.eql?(contact.id)
            puts "Copying main contact"
            project.main_contact_id = new_contact.id
            project.save(validate: false)
          end
          if establishment_main_contact_id.eql?(contact.id)
            puts "Copying establishment main contact"
            project.establishment_main_contact_id = new_contact.id
            project.save(validate: false)
          end
        end
        puts "Establishment contacts for project #{project.id} copied"
      else
        puts "No establishment contacts for project #{project.id}"
      end
    end
  end
end
