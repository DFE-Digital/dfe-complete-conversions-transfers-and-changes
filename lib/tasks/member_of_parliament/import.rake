namespace :member_of_parliament do
  desc ">> Call the Contact::Parliament importer service with a CSV of MPs"
  task :import, [:csv_path] => :environment do |_task, args|
    abort I18n.t("tasks.member_of_parliament_importer.import.error") if args[:csv_path].nil?

    csv_path = Rails.root.join(args[:csv_path])

    Import::MemberOfParliamentCsvImporterService.new.call(csv_path)
  end
end
