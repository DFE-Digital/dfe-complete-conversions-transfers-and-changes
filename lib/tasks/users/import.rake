namespace :users do
  desc ">> Call the user importer service with a CSV of users"
  task import: :environment do
    abort I18n.t("tasks.user_importer.import.error") if ENV["CSV_PATH"].nil?

    csv_path = Rails.root.join(ENV["CSV_PATH"])

    UserImporter.new.call(csv_path)
  end
end
