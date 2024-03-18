class AddTransferDeclarationOfExpenditureCertificateTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :declaration_of_expenditure_certificate_date_received, :date
    add_column :transfer_tasks_data, :declaration_of_expenditure_certificate_correct, :boolean, default: false
    add_column :transfer_tasks_data, :declaration_of_expenditure_certificate_saved, :boolean, default: false
    add_column :transfer_tasks_data, :declaration_of_expenditure_certificate_not_applicable, :boolean, default: false
  end
end
