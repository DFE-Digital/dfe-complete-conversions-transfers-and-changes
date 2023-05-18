namespace :director_of_child_services do
  desc ">> Call the Contact::DirectorOfChildServices importer service with a CSV of directors"
  task :import, [:csv_path] => :environment do |_task, args|
    abort I18n.t("tasks.director_of_child_services_importer.import.error") if args[:csv_path].nil?

    csv_path = Rails.root.join(args[:csv_path])

    DirectorOfChildServicesImporter.new.call(csv_path)
  end
end
