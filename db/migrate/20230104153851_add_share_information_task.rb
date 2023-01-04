class AddShareInformationTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_voluntary_task_lists, :share_information_email, :boolean
  end
end
