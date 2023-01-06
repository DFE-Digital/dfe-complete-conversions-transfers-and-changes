class AddInvoluntaryShareInformation < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_involuntary_task_lists, :share_information_email, :boolean
  end
end
