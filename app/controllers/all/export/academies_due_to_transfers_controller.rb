class All::Export::AcademiesDueToTransfersController < ApplicationController
  EXPORT_FILE_NAME_SUFFIX = "academies_due_to_transfer.csv"

  def new
    authorize :export

    default_from_date = Date.today.at_beginning_of_month
    default_to_date = Date.today.at_end_of_month
    @form = Export::NewAcademiesDueToTransferForm.new(from_date: default_from_date, to_date: default_to_date)
  end

  def create
    authorize :export

    @form = Export::NewAcademiesDueToTransferForm.new(export_params)

    if @form.valid?
      send_data(
        @form.export,
        filename: filename,
        type: :csv,
        disposition: "attachment"
      )
    else
      render :new
    end
  end

  def export_params
    params.require(:export_new_academies_due_to_transfer_form).permit(:from_date, :to_date)
  end

  private def filename
    "#{@form.from_date}-#{@form.to_date}_#{EXPORT_FILE_NAME_SUFFIX}"
  end
end
