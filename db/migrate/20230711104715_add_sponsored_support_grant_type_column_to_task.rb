class AddSponsoredSupportGrantTypeColumnToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :conversion_tasks_data, :sponsored_support_grant_type, :string
  end
end
