class ServiceSupport::Upload::Gias::EstablishmentsController < ApplicationController
  def new
    authorize :import
    @upload_form = ServiceSupport::Upload::Gias::UploadEstablishmentsForm.new(nil, current_user)
  end

  def upload
    authorize :import

    uploaded_file = upload_params[:uploaded_file]
    @upload_form = ServiceSupport::Upload::Gias::UploadEstablishmentsForm.new(uploaded_file, current_user)
    if @upload_form.valid?
      @upload_form.save
      time = ENV.fetch("GIAS_IMPORT_TIME", 4)
      redirect_to service_support_upload_gias_establishments_new_path, notice: I18n.t("service_support.import.gias_establishments.success", time: "#{sprintf("%02d", time)}00")
    else
      render :new
    end
  end

  private def upload_params
    params.fetch(:service_support_upload_gias_upload_establishments_form, {}).permit(:uploaded_file)
  end
end
