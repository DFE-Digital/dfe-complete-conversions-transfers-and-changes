class AddNotApplicableToReceiveGrantPaymentCertificateTask < ActiveRecord::Migration[7.1]
  def change
    add_column :conversion_tasks_data, :receive_grant_payment_certificate_not_applicable, :boolean
  end
end
