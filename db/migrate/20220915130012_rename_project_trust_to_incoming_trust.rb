class RenameProjectTrustToIncomingTrust < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :trust_ukprn, :incoming_trust_ukprn
  end
end
