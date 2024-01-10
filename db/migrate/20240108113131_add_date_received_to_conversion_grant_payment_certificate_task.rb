class AddDateReceivedToConversionGrantPaymentCertificateTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :receive_grant_payment_certificate_date_received, :date
  end
end
