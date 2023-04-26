namespace :local_authorities do
  desc ">> Call the local authority importer service with a CSV of local authorities"
  task :import, [:csv_path] => :environment do |_task, args|
    abort I18n.t("tasks.local_authority_importer.import.error") if args[:csv_path].nil?

    csv_path = Rails.root.join(args[:csv_path])

    LocalAuthorityImporter.new.call(csv_path)
  end
end
