class Import::GiasEstablishmentImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, user)
    importer = Import::Gias::EstablishmentCsvImporterService.new(file_path)
    result = importer.import!

    GiasEstablishmentImportMailer.import_notification(user, emailable_result(result)).deliver_later
  end

  def emailable_result(result)
    result.delete(:changes)
    result
  end
end
