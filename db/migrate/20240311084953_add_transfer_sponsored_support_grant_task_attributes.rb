class AddTransferSponsoredSupportGrantTaskAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :transfer_tasks_data, :sponsored_support_grant_not_applicable, :boolean, default: false
    add_column :transfer_tasks_data, :sponsored_support_grant_type, :string
  end
end
