class RemoveAttributesFromConversionGrantTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :conversion_grant_eligibility
    remove_column :conversion_voluntary_task_lists, :conversion_grant_check_payment
  end
end
