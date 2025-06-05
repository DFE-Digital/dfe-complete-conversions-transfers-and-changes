class AddFurtherConversionDeclarationOfExpenditureCertificateTaskAttributes < ActiveRecord::Migration[7.1]
  def change
    add_column :conversion_tasks_data, :declaration_of_expenditure_certificate_date_received, :date
    add_column :conversion_tasks_data, :declaration_of_expenditure_certificate_correct, :boolean, default: false
    add_column :conversion_tasks_data, :declaration_of_expenditure_certificate_saved, :boolean, default: false
  end
end
