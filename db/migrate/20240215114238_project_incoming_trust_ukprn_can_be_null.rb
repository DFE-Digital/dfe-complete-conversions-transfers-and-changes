class ProjectIncomingTrustUkprnCanBeNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :projects, :incoming_trust_ukprn, true
  end
end
