class Import::GiasEstablishmentImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, user)
    importer = Import::GiasEstablishmentCsvImporterService.new(file_path)
    result = importer.import!

    GiasEstablishmentImportMailer.import_notification(user, result).deliver_later
  end
end
