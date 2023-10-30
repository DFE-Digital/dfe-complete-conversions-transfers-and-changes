class Import::GiasHeadteacherImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, user)
    Import::GiasHeadteacherCsvImporterService.new(file_path).import!

    delete_file(file_path)
  end

  private def delete_file(file_path)
    File.delete(file_path)
  end
end
