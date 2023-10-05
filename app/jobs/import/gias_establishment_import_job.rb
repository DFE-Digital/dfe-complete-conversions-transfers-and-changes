class Import::GiasEstablishmentImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, user)
    importer = Import::GiasEstablishmentCsvImporterService.new(file_path)
    result = importer.import!

    GiasEstablishmentImportMailer.import_notification(user, result).deliver_later
    delete_file(file_path)
  end

  private def delete_file(file_path)
    File.delete(file_path)
  end
end
