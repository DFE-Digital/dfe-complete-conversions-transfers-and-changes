class RemoveEligibilityFromSponsoredSupportGrantTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversion_tasks_data, :sponsored_support_grant_eligibility, :boolean
  end
end
