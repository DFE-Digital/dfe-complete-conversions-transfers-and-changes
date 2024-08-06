class Import::GiasImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, user)
    establishments_result = import_establishments(file_path)
    GiasEstablishmentImportMailer.import_notification(user, emailable_result(establishments_result)).deliver_later

    delete_file(file_path)
  end

  def import_establishments(file_path)
    importer = Import::Gias::EstablishmentCsvImporterService.new(file_path)
    importer.import!
  end

  def emailable_result(result)
    result.delete(:changes)
    result
  end

  private def delete_file(file_path)
    File.delete(file_path)
  end
end
