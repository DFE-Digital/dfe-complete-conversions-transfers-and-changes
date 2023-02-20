class AddCheckProvisionalConversionDate < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :stakeholder_kick_off_check_provisional_conversion_date, :boolean
  end
end
