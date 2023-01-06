class AddInvoluntaryTellRegionalDeliveryOfficer < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :tell_regional_delivery_officer_email, :boolean
  end
end
