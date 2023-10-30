class ServiceSupport::Upload::Gias::UploadEstablishmentsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :uploaded_file
  attribute :user

  validate :file_present
  validate :file_type
  validate :file_size
  validate :file_headers

  IMPORT_TIME = ENV.fetch("GIAS_IMPORT_TIME", 4)

  def initialize(uploaded_file, user)
    @uploaded_file = uploaded_file
    @user = user
    super({uploaded_file: uploaded_file, user: user})
  end

  def save
    file_path_with_timestamp = file_path
    FileUtils.copy_file(@uploaded_file.path, file_path_with_timestamp)

    Import::GiasEstablishmentImportJob.set(wait_until: Date.tomorrow.in_time_zone.change(hour: IMPORT_TIME)).perform_later(file_path_with_timestamp.to_s, @user)
    Import::GiasHeadteacherImportJob.set(wait_until: Date.tomorrow.in_time_zone.change(hour: IMPORT_TIME + 1)).perform_later(file_path_with_timestamp.to_s, @user)
  end

  def file_path
    Rails.root.join("storage", "uploads", "gias", "establishments", "gias_establishments_#{DateTime.now.strftime("%Y-%m-%d-%H%M%S")}.csv")
  end

  private def file_present
    if @uploaded_file.nil?
      errors.add(:uploaded_file, message: I18n.t("errors.upload.attributes.uploaded_file.no_file"))
    end
  end

  private def file_headers
    return unless @uploaded_file.present?

    unless Import::GiasEstablishmentCsvImporterService.new(@uploaded_file.path).required_column_headers_present?
      errors.add(:uploaded_file, message: I18n.t("errors.upload.attributes.uploaded_file.file_headers"))
    end
  end

  private def file_size
    return unless @uploaded_file.present?
    file_size = File.size(@uploaded_file.tempfile)
    return true if file_size.between?(1, 150000000)

    errors.add(:uploaded_file, message: I18n.t("errors.upload.attributes.uploaded_file.file_size")) if file_size > 150000000
    errors.add(:uploaded_file, message: I18n.t("errors.upload.attributes.uploaded_file.empty_file")) if file_size == 0
  end

  private def file_type
    return unless @uploaded_file.present?
    return if @uploaded_file.content_type.include?("text/csv")

    errors.add(:uploaded_file, message: I18n.t("errors.upload.attributes.uploaded_file.file_type"))
  end
end
