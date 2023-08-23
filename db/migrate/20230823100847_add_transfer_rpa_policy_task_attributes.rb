class AddTransferRpaPolicyTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :rpa_policy_confirm, :boolean
  end
end
