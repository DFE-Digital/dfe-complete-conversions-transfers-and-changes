class RemoveTellRegionalDeliveryOfficerTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_voluntary_task_lists, :tell_regional_delivery_officer_email, :boolean
    remove_column :conversion_involuntary_task_lists, :tell_regional_delivery_officer_email, :boolean
  end
end
