namespace :project_data do
  desc ">> Update dates in the Conversion Grant payment certificate task"
  task :grant_payment_certificate_dates, [:csv_path] => :environment do |_task, args|
    abort I18n.t("tasks.grant_payment_certificate_importer.import.error") if args[:csv_path].nil?

    csv_path = Rails.root.join(args[:csv_path])

    Import::GrantCertificateDateImporterService.new.call(csv_path)
  end
end
