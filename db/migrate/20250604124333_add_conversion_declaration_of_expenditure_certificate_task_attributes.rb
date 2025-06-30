class AddConversionDeclarationOfExpenditureCertificateTaskAttributes < ActiveRecord::Migration[7.1]
  def change
    add_column :conversion_tasks_data, :declaration_of_expenditure_certificate_not_applicable, :boolean, default: false
  end
end
