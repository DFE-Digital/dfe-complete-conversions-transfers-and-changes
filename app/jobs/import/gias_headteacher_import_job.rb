class Import::GiasHeadteacherImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, user)
    result = Import::GiasHeadteacherCsvImporterService.new(file_path).import!

    GiasHeadteacherImportMailer.import_notification(user, emailable_result(result)).deliver_later

    delete_file(file_path)
  end

  def emailable_result(result)
    result.delete(:changes)
  end

  private def delete_file(file_path)
    File.delete(file_path)
  end
end
