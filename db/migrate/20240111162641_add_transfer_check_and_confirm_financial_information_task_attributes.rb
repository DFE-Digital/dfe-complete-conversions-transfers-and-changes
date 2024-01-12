class AddTransferCheckAndConfirmFinancialInformationTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :check_and_confirm_financial_information_not_applicable, :boolean
    add_column :transfer_tasks_data, :check_and_confirm_financial_information_academy_surplus_deficit, :string
    add_column :transfer_tasks_data, :check_and_confirm_financial_information_trust_surplus_deficit, :string
  end
end
