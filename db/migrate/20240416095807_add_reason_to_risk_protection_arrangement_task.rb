class AddReasonToRiskProtectionArrangementTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :risk_protection_arrangement_reason, :string
  end
end
